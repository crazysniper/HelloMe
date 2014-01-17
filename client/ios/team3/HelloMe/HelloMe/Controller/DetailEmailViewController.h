//
//  DetailEmailViewController.h
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailDTO.h"

@interface DetailEmailViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>
// 邮件标题View
@property (weak, nonatomic) IBOutlet UIView *titleView;
// 邮件主题
@property (weak, nonatomic) IBOutlet UILabel *mailTitle;
// 写信时间
@property (weak, nonatomic) IBOutlet UILabel *wroteTime;
// 收信时间
@property (weak, nonatomic) IBOutlet UILabel *receiveTime;
@property (weak, nonatomic) IBOutlet UILabel *fujianLabel;
// 文本视图View
- (IBAction)display:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textField;
// cell inpath.row
@property NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *btnAttach;

@property (weak, nonatomic) MailDTO *mailDto;
// changeSlider
@property (weak, nonatomic) IBOutlet UISlider *changeSlider;
// mailList
@property (weak, nonatomic) NSMutableArray *mailList;
// 翻邮件按钮
- (IBAction)changFont:(id)sender;
- (void)lastBtn;
- (void)nextBtn;
// 邮件显示
- (void)mailInfo:(MailDTO *)mail fontSizeSet:(float)sizeSet;
@end
