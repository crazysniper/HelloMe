//
//  WelcomeViewController.h
//  HelloMeTeam1
//
//  Created by wuhh on 12/16/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *inboxCount;
@property (weak, nonatomic) IBOutlet UILabel *draftCount;
@property (weak, nonatomic) IBOutlet UILabel *trashCount;
@property (weak, nonatomic) IBOutlet UILabel *sendCount;

@property (strong, nonatomic) NSString  *userName1;
- (IBAction)shuaxin:(id)sender;

@end
