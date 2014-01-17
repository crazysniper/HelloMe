//
//  LoginViewController.m
//  HelloMeTeam1
//
//  Created by wuhh on 12/16/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "AlertViewManager.h"
#import "User.h"
#import "MySingleton.h"
#import "GetMsgNetwork.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     //设置密码隐藏
    self.userPassward.secureTextEntry=TRUE;
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSLog(@"LoginViewController.user=%@",_userName.text);
    [MySingleton sharedSingleton].testGlobal=_userName.text;
    NSLog(@"LoginViewController.passward=%@",_userPassward.text);
    
    if(_userName.text.length==0){
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号不能为空" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
    }else if (_userPassward.text.length==0){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
    }else{
        //服务器登录
        LoginNetwork *loginNetwork=[[LoginNetwork alloc]init];
        User *user=[[User alloc]init];
        loginNetwork.delegate=self;
        user.userName=_userName.text;
        user.userPassward=_userPassward.text;
        [loginNetwork login:user];
        
    }
}

- (IBAction)back:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"LoginViewController.user=%@",_userName.text);
    NSLog(@"LoginViewController.passward=%@",_userPassward.text);

    if ([segue.identifier isEqualToString:@"welcome"]) {
        WelcomeViewController *welcome=(WelcomeViewController *)segue.destinationViewController;
        welcome.userName1=_userName.text;
        NSLog(@"welcome2=%@",welcome.userName1);
    }
}
- (IBAction)backgroundTap:(id)sender
{
    [_userName resignFirstResponder];
    [_userPassward resignFirstResponder];
}

-(void)linkServerAlert{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络中断" delegate:self cancelButtonTitle:@"登录本地用户" otherButtonTitles:nil];
    [connectAlertView show];

    //网络中断登录本地用户
    NSLog(@"~~~~~~~~~网络中断登录本地用户 ~~~~~~~~~");
    NSLog(@"LoginViewController 验证账号是否存在");
    //CoreData
    AppDelegate *_appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *userInfoEntity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:_appDelegate.managedObjectContext];
    [fetchRequest setEntity:userInfoEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@", _userName.text];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    if (!array || [array count] == 0) {
        [AlertViewManager showAlertWithTitle:@"提示" message:@"该账号不存在" buttons:[NSArray arrayWithObjects:@"请先注册", nil] onButtonClicked:^(int buttonIndex) {
            NSLog(@"请先去注册");
            [self performSegueWithIdentifier:@"goToRegist" sender:self];
        }];
        
    }else{
        NSLog(@"LoginViewController 验证密码是否正确");
        //CoreData
        AppDelegate *_appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *userInfoEntity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext: _appDelegate.managedObjectContext];
        [fetchRequest setEntity:userInfoEntity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@", _userName.text];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = NULL;
        NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error : %@\n", [error localizedDescription]);
        }
        UserInfo *info =[array objectAtIndex:0];
        if (![info.userPassward isEqualToString:_userPassward.text]) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
            [alertView show];
            _userPassward.text=nil;
        }else{
            [self performSegueWithIdentifier:@"welcome" sender:self];
        }
    }

}

//登陆成功后获取收件箱信件
-(void)loginOK{
    //获取账号
    NSString* userName=[MySingleton sharedSingleton].testGlobal;
    GetMsgNetwork *getMsgNetwork=[[GetMsgNetwork alloc]init];
    Message *msg=[[Message alloc]init ];
    msg.userName=userName;
    NSLog(@"登录时用户名是%@",msg.userName);
    [getMsgNetwork getMsg:msg];
    [self performSegueWithIdentifier:@"welcome" sender:self];
    //服务器注册成功的话，本地用CoreData也加入一条用户信息
    AppDelegate *_appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UserInfo *userinfo;
    if (!userinfo) {
        userinfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([UserInfo class]) inManagedObjectContext:[_appDelegate managedObjectContext]];
        userinfo.userName= _userName.text;
        userinfo.userPassward= _userPassward.text;
    }
    [_appDelegate saveContext];
    
}

-(void)loginFailuer{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器登录失败" delegate:self cancelButtonTitle:@"请重新登录" otherButtonTitles:nil];
    [connectAlertView show];
    _userName.text=nil;
    _userPassward.text=nil;
}

@end
