//
//  HMRootViewController.m
//  HelloMe
//
//  Created by 陳威 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMRootViewController.h"
@interface HMRootViewController ()
- (void)revealSidebar;
@end

@implementation HMRootViewController

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock withIdentity:(NSString *)IdentityId {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:IdentityId];
		_revealBlock = [revealBlock copy];
        
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
        [menuButton setBackgroundImage:[UIImage imageNamed:@"main_menu.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
        
	}
	return self;
}


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)revealSidebar {
	_revealBlock();
}
@end
