//
//  RegisterViewController.h
//  HelloMe
//
//  Created by 姚明壮 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMRootViewController.h"
#import "RegisterNetwork.h"
@class CustomTextField;
@interface RegisterViewController : HMRootViewController<NSXMLParserDelegate,registerDelegate>

@property (strong, nonatomic) IBOutlet CustomTextField *userText;
@property (strong, nonatomic) IBOutlet CustomTextField *passwordText1;
@property (strong, nonatomic) IBOutlet CustomTextField *passwordText2;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)tapAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end
