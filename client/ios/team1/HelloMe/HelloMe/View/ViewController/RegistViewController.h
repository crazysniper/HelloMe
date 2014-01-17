//
//  RegistViewController.h
//  HelloMeTeam1
//
//  Created by wuhh on 12/17/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterNetwork.h"

@interface RegistViewController : UIViewController<delegateRegister>

@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *passward;
@property (weak, nonatomic) IBOutlet UITextField *passward2;
- (IBAction)registButton:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
