//
//  SendMessageViewControl.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PICKER_KIND_DATEPICKER 1
#define PICKER_KIND_TIMEPICKER 2


@interface SendMessageViewControl : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    
    UIDatePicker *datePicker;
    UIDatePicker *timePiker;
    NSLocale *datelocale;
    NSInteger pickerKind;
    
}
- (IBAction)tapDaown:(id)sender;
- (IBAction)chooseBackgruandImage:(id)sender;
- (IBAction)UseCamera:(id)sender;
- (IBAction)receiveDateSet:(id)sender;
- (IBAction)receiveTimeSet:(id)sender;
- (IBAction)deletePicture:(id)sender;
- (IBAction)saveMessage:(id)sender;
- (IBAction)sendmessage:(id)sender;
- (IBAction)tuya:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *sentMessageView;
@property (weak, nonatomic) IBOutlet UILabel *receiveDateGet;
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeGet;
@property (weak, nonatomic) IBOutlet UITextField *letterTitle;
@property (weak, nonatomic) IBOutlet UITextView *letterContent;
@property(strong,nonatomic) NSString  *mailId;
@property(strong,nonatomic) NSString  *isFromTemp;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImage *tuyaImage;


@end
