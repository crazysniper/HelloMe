//
//  LoginViewController.h
//  HelloMeTeam1
//
//  Created by wuhh on 12/16/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginNetwork.h"
#import "GetMsgNetwork.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,delegateLogin>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassward;

- (IBAction)login:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
