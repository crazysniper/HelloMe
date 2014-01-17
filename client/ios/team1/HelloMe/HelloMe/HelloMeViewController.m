//
//  HelloMeViewController.m
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/16.
//  Copyright (c) 2013年 于翔. All rights reserved.
//

#import "HelloMeViewController.h"
#import "MessageService.h"
#import "Enum.h"
#import "Define.h"
#import "DraftViewController.h"
#import "TabBarViewController.h"
#import "Classes/Config/String.h"
#import "AlertViewManager.h"
#import "MySingleton.h"
#import "SendMsgNetwork.h"
#import "NSData+Base64.h"

@interface HelloMeViewController (){
    BOOL isFullScreen;
}

@end

@implementation HelloMeViewController
@synthesize topic;
@synthesize timeLabel,dateLabel,messageTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.addImageView addGestureRecognizer:singleTap];
    self.addImageView.userInteractionEnabled = YES;
    //指定本身为代理
    self.messageTextView.delegate = self;
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // DatePicker
	datePicker = [[UIDatePicker alloc] init];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[datePicker setMinimumDate:[dateFormatter dateFromString:@"0000-01-01"]];
    [datePicker setMaximumDate:[dateFormatter dateFromString:@"3000-12-31"]];
    
    Message *tempMsg = [[Message alloc] initWithDivision];
    [self setSendDate:tempMsg.sendYear andMonth:tempMsg.sendMonth andDay:tempMsg.sendDay];
    
    // TimePicker
	timePicker = [[UIPickerView alloc] init];
	timePicker.showsSelectionIndicator = YES;
	timePicker.delegate = self;
	timePicker.dataSource = self;
    
    [self setSendTime:tempMsg.sendHour andMinute:tempMsg.sendMinute];

    
    message = [[Message alloc] initWithDivision];
    NSLog(@"接收到草稿箱传过来的值：%@",self.test);
    if ([_Dbflg  isEqual: @"Edit"]) {
        NSLog(@"1111111-------");
        // 该份邮件处于编辑状态并显示邮件内容
        [self showMsg:self.messageEditDetail];
    }
}

-(void)hidenKeyboard
{
    [self resumeView];
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

//UITextView的协议方法，当开始编辑时监听
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移70个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-145,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
    [self resumeView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    message.topic = textField.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    message.text = textView.text;
    [self.messageTextView resignFirstResponder];
    [self resumeView];
}

- (void)leaveEditMode
{
    [self.messageTextView resignFirstResponder];
}

-(void)setSendDate:(NSString *)year andMonth:(NSString *)month andDay:(NSString *)day {
	
	message.receiveYear = year;
	message.receiveMonth = month;
	message.receiveDay = day;
	
	dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}


-(void)setSendTime:(NSString *)hour andMinute:(NSString *)minute {
	
	message.receiveHour = hour;
	message.receiveMinute = minute;
	
	timeLabel.text = [NSString stringWithFormat:@"%@点%@分", hour, minute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    //Byte *imageByte = (Byte *)[imageData bytes];
    // 把本地图片通过base64转码成为一个string类型的数据
    //imageString =[GTMBase64 stringByEncodingData:imageData];
    NSString*imageString=[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    message.sendImageString = imageString;
    //message.sendImage = imageData;
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"aaaaaaaa");
    NSLog(@"%@",fullPath);
    NSLog(@"%@",imageName);
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //当前的系统时间 yyyyMMddHHmm
    NSString *newDateDetail = [MySingleton getNowTimeDetail];
    [self saveImage:image withName:[NSString stringWithFormat:@"%@.jpg", newDateDetail]];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", newDateDetail]];
    
    message.sendFileUrl = fullPath;
    message.sendImageName = [NSString stringWithFormat:@"%@.jpg", newDateDetail];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    isFullScreen = NO;
    [self.addImageView setImage:savedImage];
    
    self.addImageView.tag = 100;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)touchesBegan:(UIEvent *)event
{
    int i = [self.view.subviews indexOfObject:self.addImageView];
    [self.addImageView.superview exchangeSubviewAtIndex:i withSubviewAtIndex:i+1];
    isFullScreen = !isFullScreen;
    // 设置图片放大动画
    [UIView beginAnimations:nil context:nil];
    // 动画时间
    [UIView setAnimationDuration:1];
    
    if (isFullScreen) {
        // 放大尺寸
        
        self.addImageView.frame = CGRectMake(0, 0, 320, 480);
    }
    else {
        // 缩小尺寸
        self.addImageView.frame = CGRectMake(219, 127, 91, 121);
    }
    
    // commit动画
    [UIView commitAnimations];
    
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }else if (actionSheet.tag == 256){
        if (pickerKind == PICKER_KIND_DATEPICKER) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *year = [dateFormatter stringFromDate:datePicker.date];
            [dateFormatter setDateFormat:@"MM"];
            NSString *month = [dateFormatter stringFromDate:datePicker.date];
            [dateFormatter setDateFormat:@"dd"];
            NSString *day = [dateFormatter stringFromDate:datePicker.date];
            [self setSendDate:year andMonth:month andDay:day];
        } else {
            // 处理时间选择器
            int hour = [timePicker selectedRowInComponent:0];
            int minute = [timePicker selectedRowInComponent:1];
            // 选择明确
            [self setSendTime:[NSString stringWithFormat:@"%02d", hour] andMinute:[NSString stringWithFormat:@"%02d", minute]];
        }
    }
}

- (IBAction)actionBack:(id)der {
    [topic resignFirstResponder];
    
}

// 发送按钮按下后，插入到数据库中
- (IBAction)sendAction:(id)sender {
    
    // 错误状态初始化
    _error = @"errorNotExist";
    if(topic.text.length==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的标题是空的哦，请确认" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
        // 画面中的数据有错误
        _error = @"errorExist";
        return;
        
    }else if (messageTextView.text.length==0)
    {
        NSLog(@"kkkkkkkk");
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的正文是空的哦，请确认" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
        // 画面中的数据有错误
        _error = @"errorExist";
        return;
        
    }else{
        //写信到服务器
        SendMsgNetwork *sendMsgNetwork=[[SendMsgNetwork alloc]init];
        sendMsgNetwork.delegate=self;
        //获取账号
        NSString* userName=[MySingleton sharedSingleton].testGlobal;
        message.userName=userName;
        [sendMsgNetwork sendMsg:message];
     }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)choosePicture:(id)sender {
    NSLog(@"选择图片");
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

- (IBAction)cancleButton:(id)sender {
    NSLog(@"helloMeViewController.flg=%@",_flg);
    if ([_flg  isEqual:@"1"]) {
       //goToDraft
      [self performSegueWithIdentifier:@"goToDraft" sender:self];
    }else{
        //goToWelcome
        [self performSegueWithIdentifier:@"goToWelcome" sender:self];
    }
    
}


// 信件详细信息是否变更
-(BOOL)isChangeMessage
{
    BOOL result = NO;
    // 判断画面的详细信件数据有没有变化
    if (![checkMessage.topic isEqualToString:message.topic]
        || ![checkMessage.text isEqualToString:message.text]
        || ![[checkMessage getSendDayViewText] isEqualToString:self.dateLabel.text]
        || ![[checkMessage getSendTimeViewText] isEqualToString:self.timeLabel.text]
        || ![checkMessage.sendFileUrl isEqualToString:message.sendFileUrl]) {
        
        result = YES;
        
    }
    
    return result;
}

// 存草稿按钮按下后，把信件详细信息存入到后台数据库
- (IBAction)saveMailAction:(id)sender {
    NSLog(@"aaaaaaaa");
    // 错误状态初始化
    _error = @"errorNotExist";
    if(topic.text.length==0)
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的标题是空的哦，请确认" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
        // 画面中的数据有错误
        _error = @"errorExist";
        return;
        
    }else if (messageTextView.text.length==0)
    {
        NSLog(@"kkkkkkkk");
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的正文是空的哦，请确认" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
        // 画面中的数据有错误
        _error = @"errorExist";
        return;
        
    }else{
        NSLog(@"bbbbbbb");
        BOOL showChangeMessage = NO;
        MessageService *service = [[MessageService alloc] init];
	
        if ([_Dbflg  isEqual: @"Add"])
        {
            message.boxID = sDraftDivision;
            message.receiveYear = message.sendYear;
            message.receiveMonth = message.sendMonth;
            message.receiveDay = message.sendDay;
            message.receiveHour = message.sendHour;
            message.receiveMinute = message.sendMinute;
            [service insertMessageInfo:message];
        }
        else if ([_Dbflg  isEqual: @"Edit"])
        {
            NSLog(@"cccccccccc");
            NSLog(@"%@",message.topic);
            if ([self isChangeMessage])
            {
                showChangeMessage = YES;
                
                // 表示确认更新的信息
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:sMessageEditTitle message:sMessageEditMessage delegate:self cancelButtonTitle:sCancleButtonText otherButtonTitles:sDoneButtonText, nil];
                alter.tag = ALERT_KIND_EDIT_PROFILE;
               [alter show];
            }
        else
        {
            // 信件信息没有变更的场合
            [service updateMessageInfo:message];
        }
	}
    
    // 提示信息不表示的场合
    if (!showChangeMessage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    }
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if(component == 0) {
		return 24; // 24小时
	} else {
		return 60; // 60分钟
	}
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)actionChooseDate:(id)sender {
    pickerKind = PICKER_KIND_DATEPICKER;
    // 发信日期变化
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [dateFormatter dateFromString:dateLabel.text];
    // DatePicker
	[datePicker setDate:date];
    // ActionSheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:@"确 定"
													otherButtonTitles:nil];
    actionSheet.tag = 256;
    [actionSheet addSubview:datePicker];
	[actionSheet showInView:self.view];
}

// 发信时间变化
- (IBAction)actionChooseTime:(id)sender {
    pickerKind = PICKER_KIND_TIMEPICKER;
    NSInteger hour = [message.sendHour intValue];
    NSInteger minute = [message.sendMinute intValue];
    if (hour == -1 || minute == -1) {
        // 选择不明确
        [timePicker selectRow:0 inComponent:0 animated:NO];
        [timePicker selectRow:0 inComponent:1 animated:NO];
      } else {
        // 选择明确
        [timePicker selectRow:hour inComponent:0 animated:NO];
    	[timePicker selectRow:minute inComponent:1 animated:NO];
    	}
    // ActionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                        delegate:self
                                                    cancelButtonTitle:nil
                                                    destructiveButtonTitle:@"确 定"
    												otherButtonTitles:nil];
    actionSheet.tag = 256;
    [actionSheet addSubview:timePicker];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if (component == 0) {
		return [NSString stringWithFormat:@"%d点", row];
	} else {
		return [NSString stringWithFormat:@"%d分", row];
	}
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSLog(@"didSelect : %d - %d", row, component);
}

- (IBAction)backgroundTap:(id)sender
{
    [topic resignFirstResponder];
    [messageTextView resignFirstResponder];
}




// 点击保存草稿之后，画面迁移到草稿箱
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarViewController *viewController = (TabBarViewController*)segue.destinationViewController;

    //goToDraft
    if ([segue.identifier isEqualToString:@"editGoToDraft"]) {
        NSLog(@"~~~~~~~~~goToDraft ~~~~~~~~~");
        [viewController setSelectedIndex:1];
    }
    
}

// 获取明细画面的数据
-(void) showMsg:(Message *)msg{
    NSString * strSendYear = msg.receiveYear;
    NSString * strSendMonth = msg.receiveMonth;
    NSString * strSendDay = msg.receiveDay;
    NSString * strSendHour = msg.receiveHour;
    NSString * strSendMinute = msg.receiveMinute;
    self.topic.text = msg.topic;
    messageTextView.text=msg.text;
    
    // 接受发信日期并且format
    NSString *strSendDate = sNoValue;
    if (strSendYear.length == 0) {
        strSendDate = sSendTimeIsNull;
    } else{
        strSendDate = [NSString stringWithFormat:@"%@年%@月%@日",strSendYear,strSendMonth,strSendDay];
    }
    self.dateLabel.text = strSendDate;
    
    // 接受发信时间并且format
    NSString *strSendTime = sNoValue;
    if (strSendHour.length == 0) {
        strSendTime = sSendTimeIsNull;
    } else{
        strSendTime = [NSString stringWithFormat:@"%@点%@分",strSendHour,strSendMinute];
    }
    self.timeLabel.text = strSendTime;
    NSString *searchFullpath = nil;
    // 从db检索图片信息
    if (!searchFullpath.length == 0) {
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:searchFullpath];
        isFullScreen = NO;
        [self.addImageView setImage:savedImage];
        self.addImageView.tag = 100;
    }
    
    
    
    // 接受邮件中附带的图片路径
    self.imageUrl.text = msg.sendFileUrl;
    message.messageID = msg.messageID;
    message.topic = msg.topic;
    message.text = msg.text;
    message.sendDay = msg.sendDay;
    message.sendMonth = msg.sendMonth;
    message.sendYear = msg.sendYear;
    message.sendHour = msg.sendHour;
    message.sendMinute = msg.sendMinute;
    message.sendFileUrl = msg.sendFileUrl;
    // 初期化的画面数据记录
    checkMessage = [[Message alloc]init];
    checkMessage.topic = msg.topic;
    checkMessage.text = msg.text;
    checkMessage.sendYear = msg.sendYear;
    checkMessage.sendMonth = msg.sendMonth;
    checkMessage.sendDay = msg.sendDay;
    checkMessage.sendHour = msg.sendHour;
    checkMessage.sendMinute = msg.sendMinute;
    checkMessage.sendFileUrl = msg.sendFileUrl;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MessageService *service = [[MessageService alloc] init];
        [self performSegueWithIdentifier:@"goToDraft" sender:self];
            [service updateMessageInfo:message];
    }
}

-(void)linkServerAlert{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [connectAlertView show];
}

-(void)sendFailure{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败，请重新发送" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [connectAlertView show];
}

-(void)sendOK{
    //网络连上的话，往本地数据库插入数据
    MessageService *service = [[MessageService alloc] init];
    message.boxID = sReceiveDivision;
    [service insertMessageInfo:message];
}
@end
