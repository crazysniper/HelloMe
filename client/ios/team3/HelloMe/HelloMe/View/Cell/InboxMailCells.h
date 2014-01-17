//
//  InboxMailCells.h
//  HelloMe
//
//  Created by smartphone22 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface InboxMailCells : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *inboxMailTitle;
@property (weak, nonatomic) IBOutlet UILabel *inboxMailTime;
@property (weak, nonatomic) IBOutlet UILabel *inboxMailText;
@property (weak, nonatomic) IBOutlet UIImageView *inboxMailMes;
@property (weak, nonatomic) IBOutlet UIView *inboxContentView;
@end
