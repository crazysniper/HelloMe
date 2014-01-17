//
//  SettingViewController.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "SettingViewController.h"
#import "ImageFactory.h"
#import "ColorUtil.h"
#import "SettingCell.h"
#import "SetLogoutCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ThemeManager.h"
@interface SettingViewController (){
    NSArray *accoundArray;
    NSArray *receiveArray;
    NSArray *theamArray;
    NSArray *otherArray;
}

@end

@implementation SettingViewController

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
	// Do any additional setup after loading the view.
    [self regitserAsObserver];
    [self configureViews];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName, nil]];
    accoundArray = [[NSArray alloc]initWithObjects:@"个人资料",@"清空缓存", nil];
    receiveArray = [[NSArray alloc]initWithObjects:@"接收未来邮件", nil];
    theamArray = [[NSArray alloc]initWithObjects:@"个性主题",@"个性信纸", nil];
    otherArray = [[NSArray alloc]initWithObjects:@"版本信息",@"意见反馈",@"关于", nil];
    
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return accoundArray.count;
            break;
        case 1:
            return receiveArray.count;
            break;
        case 2:
            return theamArray.count;
            break;
        case 3:
            return otherArray.count;
            break;
        case 4:
            return 1;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (section == 4) {
        static NSString *CellIdentifier = @"SetLogoutCell";
        SetLogoutCell *cell = (SetLogoutCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SetLogoutCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"退出本账号";
        cell.imageView.image = [ImageFactory imageRectStrokeWithColor:[UIColor redColor] size:CGSizeMake(300, 43) lineColor:[ColorUtil colorFromColorString:@"ffffff"] lineWidth:0.0f];
        return cell;
    }else{
        static NSString *CellIdentifier  = @"SettingCell";
        SettingCell *cell = (SettingCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0:
                
                cell.setNameLabel.text = [accoundArray objectAtIndex:row];
                break;
            case 1:
                cell.setNameLabel.text = [receiveArray objectAtIndex:row];
                cell.receiveSwitch.hidden = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            case 2:
                
                cell.setNameLabel.text = [theamArray objectAtIndex:row];
                break;
            case 3:
                cell.setNameLabel.text = [otherArray objectAtIndex:row];
                if (row==0) {
                    cell.versonLabel.hidden = NO;
                    cell.versonLabel.text = @"V1.0";
                }
                
                break;
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = [indexPath section];
    NSUInteger row =[indexPath row];
    switch (section) {
        case 0:
            if (row == 0) {
              //  [self performSegueWithIdentifier:@"account" sender:self];
            }else if(row == 1){
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"清空完成";
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }
            break;
        case 1:
//            if (row == 0) {
//                [self performSegueWithIdentifier:@"keychainSegue" sender:self];
//            }else if(row == 1){
//                [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
//            }else if(row == 2){
//                [self performSegueWithIdentifier:@"alertSegue" sender:self];
//            }else if(row == 3){
//                [self performSegueWithIdentifier:@"pickerSegue" sender:self];
//            }
            break;
        case 2:
            if (row == 0) {
                [self performSegueWithIdentifier:@"theamSegue" sender:self];
            }else if(row == 1){
                //[self performSegueWithIdentifier:@"ProfileSegue" sender:self];
            }
            break;
        case 3:
            if (row == 0) {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"已是最新版本";
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }else if(row == 1){
                //[self performSegueWithIdentifier:@"ProfileSegue" sender:self];
            }
            break;
        case 4:
            if (row == 0) {
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                LoginViewController *loginVC = [[LoginViewController alloc]initWithView];
                appDelegate.window.rootViewController  = loginVC;
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
