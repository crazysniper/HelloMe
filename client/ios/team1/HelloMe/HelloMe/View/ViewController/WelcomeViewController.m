//
//  WelcomeViewController.m
//  HelloMeTeam1
//
//  Created by wuhh on 12/16/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HelloMeViewController.h"
#import "TabBarViewController.h"
#import "MySingleton.h"
#import "MessageService.h"
#import "String.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarViewController *viewController = (TabBarViewController*)segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"goToWrite"]) {
        HelloMeViewController *helloMeViewController=(HelloMeViewController *)segue.destinationViewController;
        helloMeViewController.flg=@"2";
        helloMeViewController.Dbflg=@"Add";
        NSLog(@"welcome flg=%@",helloMeViewController.flg);
    }
    //goToInbox
    if ([segue.identifier isEqualToString:@"goToInbox"]) {
        [viewController setSelectedIndex:0];
    }
    
    //goToDraft
    if ([segue.identifier isEqualToString:@"goToDraft"]) {
        [viewController setSelectedIndex:1];
    }
    //goToTrash
    if ([segue.identifier isEqualToString:@"goToTrash"]) {
        [viewController setSelectedIndex:2];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    _user.text =[MySingleton sharedSingleton].testGlobal;

    //set inbox count
    MessageService *service1 = [[MessageService alloc]init];
    _inboxCount.text = [service1 getCountWithDivision:@"1"];
    
    //set draft count
    MessageService *service2 = [[MessageService alloc]init];
    _draftCount.text = [service2 getCountWithDivision:@"2"];
    
    //set trash count
    MessageService *service3 = [[MessageService alloc]init];
    _trashCount.text = [service3 getCountWithDivision:@"3"];
    
    //set outbox count
    MessageService *service4 = [[MessageService alloc]init];
    _sendCount.text = [service4 getCountWithDivision:@"4"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实时刷新欢迎画面数据
- (IBAction)shuaxin:(id)sender {
    //set inbox count
    MessageService *service1 = [[MessageService alloc]init];
    _inboxCount.text = [service1 getCountWithDivision:@"1"];
    
    //set draft count
    MessageService *service2 = [[MessageService alloc]init];
    _draftCount.text = [service2 getCountWithDivision:@"2"];
    
    //set trash count
    MessageService *service3 = [[MessageService alloc]init];
    _trashCount.text = [service3 getCountWithDivision:@"3"];
    
    //set outbox count
    MessageService *service4 = [[MessageService alloc]init];
    _sendCount.text = [service4 getCountWithDivision:@"4"];
}
@end
