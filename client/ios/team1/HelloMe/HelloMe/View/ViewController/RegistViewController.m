//
//  RegistViewController.m
//  HelloMeTeam1
//
//  Created by wuhh on 12/17/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "AlertViewManager.h"
#import "User.h"
#import "MySingleton.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

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
    //设置密码隐藏
    self.passward.secureTextEntry=TRUE;
    self.passward2.secureTextEntry=TRUE;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registButton:(id)sender {
    NSLog(@"RegistViewController.user=%@",_user.text);
    NSLog(@"RegistViewController.passward=%@",_passward.text);
    NSLog(@"RegistViewController.passward2=%@",_passward2.text);
    
    
    if(_user.text.length==0){
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号不能为空" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
    } else if (_passward.text.length==0){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
    }else if (_passward2.text.length==0){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次确认密码" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
    }else if (![_passward.text isEqualToString:_passward2.text]){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不相同" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
        _passward.text=nil;
        _passward2.text=nil;
    }else{
        //服务器注册
        RegisterNetwork *registerNetwork=[[RegisterNetwork alloc]init];
        registerNetwork.delegate=self;
        User *user=[[User alloc]init];
        user.userName=_user.text;
        user.userPassward=_passward.text;
        [registerNetwork register:user];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [_user resignFirstResponder];
    [_passward resignFirstResponder];
    [_passward2 resignFirstResponder];
}

-(void)linkServerAlert{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络中断，无法注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [connectAlertView show];
    _user.text=nil;
    _passward.text=nil;
    _passward2.text=nil;
}

-(void)registerFailuer{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名已存在，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [connectAlertView show];
    _user.text=nil;
    _passward.text=nil;
    _passward2.text=nil;
}

-(void)registerOK{
    //注册成功
    [AlertViewManager showAlertWithTitle:@"提示" message:@"注册成功" buttons:[NSArray arrayWithObjects:@"去登录", nil] onButtonClicked:^(int buttonIndex) {
        NSLog(@"去登录");
        [self performSegueWithIdentifier:@"goToLogin" sender:self];
    }];
}
@end
