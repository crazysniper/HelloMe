//
//  LoginViewController.h
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginNetwork.h"
@class CustomTextField;
@interface LoginViewController : UIViewController<UIScrollViewDelegate,loginDelegate>{
   
}
//指导页面UI
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;
//登陆页面UI
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet CustomTextField *accountText;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)viewTapAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (id)initWithView;

- (IBAction)testAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *registerImg;


@end
