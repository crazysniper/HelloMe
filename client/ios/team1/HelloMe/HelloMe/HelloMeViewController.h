//
//  HelloMeViewController.h
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/16.
//  Copyright (c) 2013年 于翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "Enum.h"
#import "SendMsgNetwork.h"

#define PICKER_KIND_DATEPICKER 1
#define PICKER_KIND_TIMEPICKER 2
#define ALERT_KIND_EDIT_PROFILE 9999

@interface HelloMeViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,delegateSend>
{
    UIDatePicker *datePicker;
    UIPickerView *timePicker;
    Message	*message;
    Message	*checkMessage;
    NSInteger pickerKind;
    IBOutlet UIButton *selectDateBtn;
    IBOutlet UIButton *selectTimeBtn;
    IBOutlet UIButton *sendBtn;
    //IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *choosePicture;
    ActionType actionTypeInfo;

}

@property (weak, nonatomic) IBOutlet UITextField *topic;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) NSString *test;
@property (strong,nonatomic) NSString *flg;
@property (strong,nonatomic) NSString *Dbflg;
@property (strong,nonatomic) NSString *error;
@property (weak,nonatomic) Message *messageEditDetail;
@property (weak, nonatomic) IBOutlet UILabel *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

- (IBAction)actionBack:(id)sender;
- (IBAction)sendAction:(id)sender;

- (IBAction)choosePicture:(id)sender;

- (IBAction)backgroundTap:(id)sender;
-(void)touchesBegan:(UIEvent *)event;
@end
