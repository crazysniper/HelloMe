//
//  ViewController.m
//  HelloMeTeam1
//
//  Created by wuhh on 12/16/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)regist:(id)sender {
    NSLog(@"regist");

}
- (IBAction)login:(id)sender {
    NSLog(@"login");

}
@end
