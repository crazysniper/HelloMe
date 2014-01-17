//
//  RegisterViewController.m
//  HelloMe
//
//  Created by 姚明壮 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
#import "ColorUtil.h"
#import "ImageFactory.h"
#import "MBProgressHUD.h"
#import "UIImage.h"
#import "RegisterNetwork.h"
#import "LoginDTO.h"
#import "GetNewMailsNetwork.h"
#import "SendMailNetwork.h"
#import "ThemeManager.h"
@interface RegisterViewController ()<MBProgressHUDDelegate>
{
    NSDictionary *result;
    MBProgressHUD *HUDLoading;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self regitserAsObserver];
    [self configureViews];
    [self.navigationItem setHidesBackButton:YES];
    if (IOS_VERSION >= 7.0f) {
        self.navigationController.navigationBar.barTintColor = [ColorUtil colorFromColorString:@"232323"];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[ImageFactory imageRectangleWithColor:[[ThemeManager sharedInstance]colorWithColorName] size:self.navigationController.navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
    }

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 25.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //账号输入框设置
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_face.png"]];
    _userText.leftView = img;
    _userText.leftViewMode = UITextFieldViewModeAlways;
    //密码输入框设置
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pass.png"]];
    _passwordText1.leftView= img2;
    _passwordText1.leftViewMode = UITextFieldViewModeAlways;
    _passwordText1.secureTextEntry=YES;
    //重复密码输入框设置
    UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pass.png"]];
    _passwordText2.leftView= img3;
    _passwordText2.secureTextEntry=YES;
    _passwordText2.leftViewMode = UITextFieldViewModeAlways;
    //注册按钮设置
    [_registerButton setBackgroundImage:[ImageFactory imageRectangleWithColor:[ColorUtil colorFromColorString:@"ff3d00"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    result = [[NSDictionary alloc]init];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)regitserAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(configureViews)
                   name:ThemeDidChangeNotification
                 object:nil];
}
- (void)configureViews
{
    
    if (IOS_VERSION >= 7.0f) {
        self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedInstance]colorWithColorName];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[ImageFactory imageRectangleWithColor:[[ThemeManager sharedInstance]colorWithColorName] size:self.navigationController.navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//输入法框上下移动设置0
- (IBAction)tapAction:(id)sender {
    
    if ([self.userText isEditing]) {
        [self.userText resignFirstResponder];
    }
    if ([self.passwordText1 isEditing]) {
        [self.passwordText1 resignFirstResponder];
    }
    if ([self.passwordText2 isEditing]) {
        [self.passwordText2 resignFirstResponder];
    }

}
- (void)registerSuccessd{
    [HUDLoading hide:YES];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"checkmark.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"恭喜你，注册成功";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    [self backAction];
}
- (void)registerFailed{
    [HUDLoading hide:YES];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"注册失败或者用户名已经被占用";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
}
- (void)registerNetworkError{
    [HUDLoading hide:YES];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"网络连接错误";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
//注册按钮点击事件
- (IBAction)registerAction:(id)sender {
    if ([self validateContent]) {
        HUDLoading = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUDLoading];
        HUDLoading.delegate = self;
        HUDLoading.labelText = @"正在注册";
        [HUDLoading show:YES];
        RegisterNetwork *network = [[RegisterNetwork alloc]init];
        LoginDTO *dto = [[LoginDTO alloc]init];
        dto.userName = self.userText.text;
        dto.password = self.passwordText1.text;
        network.delegate = self;
        [network register:dto ];
    }
//    GetNewMailsNetwork*network=[[GetNewMailsNetwork alloc] init];
//    MailDTO*dto=[[MailDTO alloc] init];
//    dto.userName=@"ymz";
//    dto.sendTime=@"201312201310";
//    [network getNewMails:dto];
//    SendMailNetwork*network=[[SendMailNetwork alloc]init];
//    MailDTO*dto=[[MailDTO alloc] init];
//    dto.sendTime=@"201312201400";
//    dto.receiveTime=@"201312201800";
//    dto.subject=@"shuaige";
//    dto.text=@"haohaoxuexi";
//    dto.userName=@"ymz";
//    for (int i=0; i<5; i++) {
//        [network saveMail:dto];
//    }
}
- (BOOL)validateContent {
    
    if (!self.userText.text || self.userText.text.length == 0) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入账号";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return NO;
    }
    if (!self.passwordText1.text || self.passwordText1.text.length == 0) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入密码";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        return NO;
    }
    if(![_passwordText1.text isEqualToString:_passwordText2.text])
    {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"两次密码输入不一样";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        _passwordText1.text=NULL;
        _passwordText2.text=NULL;
        return NO;
        
    }
    
    return YES;
}
//输入法框上下移动设置1
- (IBAction)userReturn:(id)sender {
    [self.userText resignFirstResponder];
}
//输入法框上下移动设置2
- (IBAction)password1Return:(id)sender {
    [self.passwordText1 resignFirstResponder];
}
//输入法框上下移动设置3
- (IBAction)password2Return:(id)sender {
    [self.passwordText2 resignFirstResponder];
}
//判断两次密码是否一致

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"viewMoveup" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
//控制屏幕上下移动（下面四个方法）
- (IBAction)password1Up:(id)sender {
    [self animateTextField:sender up:YES];
}
- (IBAction)password1Down:(id)sender {
    [self animateTextField:sender up:NO];
}
- (IBAction)password2Up:(id)sender {
        [self animateTextField:sender up:YES];
}
- (IBAction)password2Down:(id)sender {
        [self animateTextField:sender up:NO];
}



@end
