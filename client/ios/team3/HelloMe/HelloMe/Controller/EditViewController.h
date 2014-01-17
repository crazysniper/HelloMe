//
//  EditViewController.h
//  HelloMe
//
//  Created by Eva.yuanzi on 2013/12/16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "ViewController.h"
#import "SendMailNetwork.h"

@interface EditViewController : ViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,sendMailDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *titleView;

//前画面传值flag
@property (nonatomic,strong) NSString *drafttoEdit;
// mailDto
@property (weak, nonatomic) MailDTO *mailDto;
// mailList
@property (weak, nonatomic) NSMutableArray *mailList;
// index
@property  NSInteger index;

// 邮件发送按钮

- (IBAction)sendmail:(id)sender;

// 日期选取按钮
- (IBAction)selecttime:(id)sender;

// 收信时间设置
@property (strong, nonatomic) IBOutlet UILabel *SupposedTime;

// 主题编辑区
@property (strong, nonatomic) IBOutlet UITextField *Theme;








@end
