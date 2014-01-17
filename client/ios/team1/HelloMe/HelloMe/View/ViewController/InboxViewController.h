//
//  InboxViewController.h
//  HelloMeTeam1 收件箱
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface InboxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *inbox_Number;
@property (weak,nonatomic) Message *messageInbox;
@property (nonatomic, retain) NSMutableArray *messageArrayforInbox;
@property (weak, nonatomic) IBOutlet UILabel *inboxCount;

@end
