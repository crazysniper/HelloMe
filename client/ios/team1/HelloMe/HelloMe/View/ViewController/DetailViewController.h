//
//  ReadViewController.h
//  HelloMeTeam1 收件箱回收箱信件详情显示
//
//  Created by wuhh on 12/18/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface DetailViewController : UIViewController<UIScrollViewDelegate>

@property (weak,nonatomic) Message *messageDetail;
@property (weak, nonatomic) IBOutlet UILabel *msgTopic;
@property (weak, nonatomic) IBOutlet UILabel *receiveTime;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
@property (weak, nonatomic) IBOutlet UIScrollView *msgText;
@property (weak, nonatomic) IBOutlet UIImageView *attachImg;

@property (strong, nonatomic) NSString  *boxId;

@end
