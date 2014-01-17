//
//  LoginViewController.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "ColorUtil.h"
#import "ImageFactory.h"
#import "AppDelegate.h"
#import "HMMenuCell.h"
#import "HMMenuViewController.h"
#import "HMRootViewController.h"
#import "HMRevealViewController.h"
#import "InboxViewController.h"
#import "DraftViewController.h"
#import "TrashViewController.h"
#import "HassendViewController.h"
#import "SettingViewController.h"
#import "LoginDTO.h"
#import "UserAccountLogic.h"
#import "MBProgressHUD.h"
#import "UIImage.h"
#import "LoginNetwork.h"
#import "KeychainAccessor.h"
#import "UIImage.h"
@interface LoginViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUDLoading;
}
@property (nonatomic, strong) HMRevealViewController *revealController;
@property (nonatomic, strong) HMMenuViewController *menuController;
@end

@implementation LoginViewController
@synthesize revealController, menuController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (id)initWithView {
    if (self = [super initWithNibName:nil bundle:nil]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
	}
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  //  if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLaunch"]) {
        NSLog(@"第一次打开,进入指导页面");
        _tutorialView.hidden = NO;
        _loginView.hidden = YES;
        _tutorialScrollView.contentSize = CGSizeMake(320*2, 346);
        for (int i = 0; i < 2; i++) {
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 346)];
            
            
            UIImage *aa = [UIImage imageNamed:[NSString stringWithFormat:@"menu%d.jpg",i+2]];
            aa = [aa TransformtoSize:CGSizeMake(320, 568)];
            UIImageView *image = [[UIImageView alloc]initWithImage:aa];
            
            [contentView addSubview:image];
            [_tutorialScrollView addSubview:contentView];
        }
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
 //   }
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_face.png"]];
    _accountText.leftView = img;
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pass.png"]];
    _passwordText.leftView= img2;
    _passwordText.leftViewMode = UITextFieldViewModeAlways;
    [_loginButton setBackgroundImage:[ImageFactory imageRectangleWithColor:[ColorUtil colorFromColorString:@"ff3d00"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[ImageFactory imageRectangleWithColor:[ColorUtil colorFromColorString:@"e63700"] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (_tutorialView.hidden == NO) {
        UIScrollView *scrollView = sender;
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _tutorialPageControl.currentPage = page;
        NSLog(@"page == %d",page);
        if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
            NSLog(@"结束");
            _tutorialView.hidden = YES;
            _loginView.hidden = NO;
        }
    }
}
- (IBAction)viewTapAction:(id)sender {
    [self hiddenKeyboard];
}
- (void)loginSuccessd
{
    [HUDLoading hide:YES];
    NSLog(@"登陆成功");
    [self toMain];
}
- (void)loginFailed{
     NSLog(@"登陆失败");
    [HUDLoading hide:YES];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"登陆失败,请重新登陆";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
- (void)loginNetworkError{
    [HUDLoading hide:YES];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"网络连接错误";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];

}
- (IBAction)loginAction:(id)sender {
    [self hiddenKeyboard];
    if ([self validateContent]) {
        HUDLoading = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUDLoading];
        HUDLoading.delegate = self;
        HUDLoading.labelText = @"正在登陆";
        [HUDLoading show:YES];

        LoginDTO *dto = [[LoginDTO alloc]init];
        dto.userName = self.accountText.text;
        dto.password = self.passwordText.text;
        LoginNetwork *network = [[LoginNetwork alloc]init];
        network.delegate = self;
        [network login:dto];
    }

}

- (IBAction)testAction:(id)sender {
     [self toMain];
}
- (BOOL)validateContent {
    
    if (!self.accountText.text || self.accountText.text.length == 0) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入账号";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return NO;
    }
    if (!_passwordText.text || _passwordText.text.length == 0) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入密码";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return NO;
    }
    
    return YES;
}

- (void)hiddenKeyboard {
    if ([self.accountText isEditing]) {
        [self.accountText resignFirstResponder];
    }
    if ([self.passwordText isEditing]) {
        [self.passwordText resignFirstResponder];
    }
}
- (void)toMain{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.revealController = [[HMRevealViewController alloc] initWithNibName:nil bundle:nil];
	self.revealController.view.backgroundColor = bgColor;
	
	RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kHMRevealSidebarDefaultAnimationDuration];
	};
	
	NSArray *headers = @[
                         [NSNull null],
                         @"EMAIL"
                         ];
	NSArray *controllers = @[
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[InboxViewController alloc]initWithTitle:@"收件箱" withRevealBlock:revealBlock withIdentity:@"InboxViewController"]],
                                 
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[InboxViewController alloc]initWithTitle:@"收件箱" withRevealBlock:revealBlock withIdentity:@"InboxViewController"]],
//                                 [[UINavigationController alloc] initWithRootViewController:[[HassendViewController alloc] initWithTitle:@"已发送" withRevealBlock:revealBlock withIdentity:@"HassendViewController"]],
                                 [[UINavigationController alloc] initWithRootViewController:[[TrashViewController alloc] initWithTitle:@"垃圾箱" withRevealBlock:revealBlock withIdentity:@"TrashViewController"]],
                                 [[UINavigationController alloc] initWithRootViewController:[[DraftViewController alloc] initWithTitle:@"草稿箱" withRevealBlock:revealBlock withIdentity:@"DraftViewController"]],
                                 [[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] initWithTitle:@"设置" withRevealBlock:revealBlock withIdentity:@"SettingViewController"]]
                                 ]
                             ];
	NSArray *cellInfos = @[
                           @[
                               @{ }
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"main_inbox.png"], kSidebarCellTextKey: NSLocalizedString(@"收件箱", @"")},
//                               @{kSidebarCellImageKey: [UIImage imageNamed:@"main_hassend.png"], kSidebarCellTextKey: NSLocalizedString(@"已发送", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"main_trash.png"], kSidebarCellTextKey: NSLocalizedString(@"垃圾箱", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"main_draft.png"], kSidebarCellTextKey: NSLocalizedString(@"草稿箱", @"")},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"main_setting.png"], kSidebarCellTextKey: NSLocalizedString(@"设置", @"")},
                               ]
                           ];
	
	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
		}];
	}];
	
	self.menuController = [[HMMenuViewController alloc] initWithSidebarViewController:self.revealController
																		  withHeaders:headers
																	  withControllers:controllers
																		withCellInfos:cellInfos];
    appDelegate.window.rootViewController  = self.revealController;
}
@end
