//
//  SendMessageViewControl.m
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "SendMessageViewControl.h"
#import "Sqlite3Util.h"
#import "Photo.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface SendMessageViewControl (){
    Sqlite3Util *sqlUtil;
    NSString *receiveDate;
    NSString *receiveTime;
    int isFromLogout;
    BOOL isFullScreen;
}

@end

@implementation SendMessageViewControl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.imageView addGestureRecognizer:singleTap];
    self.imageView.userInteractionEnabled = YES;
    
    self.sentMessageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boxbgimg.jpg"]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"信箱" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoReceiveBox)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSString *backButtonTitle;
    if ([self.isFromTemp isEqualToString:@"YES"]) {
        backButtonTitle = @"返回";
    }else{
        backButtonTitle = @"注销";
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    sqlUtil = [[Sqlite3Util alloc]init];
    [sqlUtil initDataBase];
    [sqlUtil createTables];
    
    self.letterTitle.delegate=self;
    self.letterContent.layer.borderWidth=0.5;
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 261, 156)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    // DatePicker
	datePicker = [[UIDatePicker alloc] init];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[datePicker setMinimumDate:[dateFormatter dateFromString:@"20130101"]];
    [datePicker setMaximumDate:[dateFormatter dateFromString:@"22001231"]];
    NSDate *date = [NSDate date];
    [datePicker setDate:date animated:YES];
    
    timePiker=[[UIDatePicker alloc]init];
    [timePiker setDatePickerMode:UIDatePickerModeTime];
    NSDate *time =[NSDate date];
    [timePiker setDate:time animated:YES];
    NSMutableDictionary *selectedTempDic = [[NSMutableDictionary alloc]init];
    
    if(_tuyaImage != nil){
        self.imageView.image = self.tuyaImage;
    }
    // 从草稿箱迁移
    if([_mailId length] > 0){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        selectedTempDic = [sqlUtil selectMail:appDelegate.kUserName WithMailId:_mailId withBoxId:@"3"];
        // 标题
        _letterTitle.text = [selectedTempDic valueForKey:@"subject"];
        // 内容
        _letterContent.text = [selectedTempDic valueForKey:@"content"];
        // 收信时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyyMMddHHmm"];
        
        NSDate *dateTime = [formatter dateFromString:[selectedTempDic valueForKey:@"receive_time"]];
        receiveDate = [[selectedTempDic valueForKey:@"receive_time"] substringToIndex:8];
        receiveTime = [[selectedTempDic valueForKey:@"receive_time"] substringFromIndex:8];
        
        NSString *year = [[selectedTempDic valueForKey:@"receive_time"] substringToIndex:4];
        NSString *month = [[selectedTempDic valueForKey:@"receive_time"] substringWithRange:NSMakeRange(4,2)];
        NSString *day = [[selectedTempDic valueForKey:@"receive_time"] substringWithRange:NSMakeRange(6,2)];
        NSString *hour = [[selectedTempDic valueForKey:@"receive_time"] substringWithRange:NSMakeRange(8,2)];
        NSString *minite = [[selectedTempDic valueForKey:@"receive_time"] substringWithRange:NSMakeRange(10,2)];
        
        [self setReceiveDate:year andMonth:month andDay:day];
        [self setReceiveTime:hour andminite:minite];
        
        [datePicker setDate:dateTime];
        [timePiker setDate:dateTime];
        
        
        
        // 图片
        NSString *imageString = [selectedTempDic valueForKey:@"send_file_name"];
        NSLog(@"%@图片",imageString);
        //如果imgerView有图片
        if (![imageString isEqualToString:@""]) {
            NSLog(@"选择UIImageView中的照片");
            //   self.image.image=[UIImage imageNamed:@"Default.png"];
            self.imageView.image= [Photo string2Image:imageString];
            NSLog(@"图片解码完成");
            //NSLog(@"%@图片编码值",imageString);
        }
    }else{
        // 标题
        _letterTitle.text = @"标题";
        // 内容
        _letterContent.text = @"邮件正文";
    }
    
}

- (void)viewDidUnload {
    // 关闭数据库
    [sqlUtil closeDB];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    _mailId = @"";
}

//标题输入点击return隐藏软键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField  resignFirstResponder];
    return YES;}

//退出按钮
-(void)logOut{
    isFromLogout = 0;
    if (![self.isFromTemp isEqualToString:@"YES"]) {
        UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [logoutAlertView show];
        logoutAlertView = nil;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *msg = [[NSString alloc] initWithFormat:@"您点击的是第%d个按钮!",buttonIndex];
    NSLog(@"msg:%@",msg);
    
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1 && isFromLogout==0){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(buttonIndex == 0 && isFromLogout==1){
        self.receiveDateGet.text=@"";
        self.receiveTimeGet.text=@"";
        self.imageView.image=nil;
        self.letterTitle.text=@"";
        self.letterContent.text=@"";
    }else if(buttonIndex == 1 && isFromLogout==1){
        [self gotoReceiveBox];
    }else if(buttonIndex == 1 && isFromLogout==2){
        //收信时间空提示
        if (receiveDate.length==0||receiveTime.length==0) {
            UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择收信时间!" delegate:self cancelButtonTitle:@"去选择" otherButtonTitles:nil, nil];
            [nameAlertView show];
            return;
        }
        
        // 获取系统当前时间
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        //设置时间输出格式：
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        [df setDateFormat:@"yyyyMMddHHmm"];
        NSString * crrentTime = [df stringFromDate:currentDate];
        
        NSString *box_id = @"3";
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString *user_id = appDelegate.kUserName;
        NSString *send_time = crrentTime;
        NSString *receive_time =[receiveDate stringByAppendingString:receiveTime];
        NSString *subject = self.letterTitle.text;
        NSString *content = self.letterContent.text;
        
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setValue:box_id forKey:@"box_id"];
        [args setValue:user_id forKey:@"user_id"];
        [args setValue:send_time forKey:@"send_time"];
        [args setValue:receive_time forKey:@"receive_time"];
        [args setValue:subject forKey:@"subject"];
        [args setValue:content forKey:@"content"];
        //接受页面信息
        NSString *imageString=@"";
        //如果imgerView有图片
        if (self.imageView.image) {
            NSLog(@"选择UIImageView中的照片");
            imageString=[Photo image2String:self.imageView.image];
            NSLog(@"图片编码完成");
            //NSLog(@"%@图片编码值",imageString);
        }
        [args setValue:imageString forKey:@"send_file_name"];
        
        [sqlUtil insertTable:@"mailbox" withArgs:args];
        
        
        [self performSegueWithIdentifier:@"gotoTemp" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TabBarViewController *viewController = (TabBarViewController*)segue.destinationViewController;
    
    //goToTemp
    if ([segue.identifier isEqualToString:@"gotoTemp"]) {
        [viewController setSelectedIndex:2];
    }
}

//跳转到收件箱
-(void)gotoReceiveBox{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewbar"]
                       animated:YES completion:nil];
}

//获得页面信息存数据库
-(void)sentMessage{
    isFromLogout =1;
    //标题空提示
    if (self.letterTitle.text.length==0) {
        UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有填写主题。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [nameAlertView show];
        return;
    }
    //内容空提示（图片和内容都无）
    if(self.imageView.image==nil&&self.letterContent.text.length==0){
        UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信件内容为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [nameAlertView show];
        return;
    }
    //收信时间空提示
    if (receiveDate.length==0||receiveTime.length==0) {
        UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择收信时间!" delegate:self cancelButtonTitle:@"去选择" otherButtonTitles:nil, nil];
        [nameAlertView show];
        return;
    }
    
    //接受页面信息
    NSString *imageString=@"";
    //如果imgerView有图片
    if (self.imageView.image) {
		NSLog(@"选择UIImageView中的照片");
		imageString=[Photo image2String:self.imageView.image];
        NSLog(@"图片编码完成");
		//NSLog(@"%@图片编码值",imageString);
	}
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMddHHmm"];
    NSString * crrentTime = [df stringFromDate:currentDate];
    
    
    
    NSString *box_id = @"1";
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *user_id = appDelegate.kUserName;
    NSString *send_time = crrentTime;
    
    NSString *receive_time =[receiveDate stringByAppendingString:receiveTime];
    NSString *subject = self.letterTitle.text;
    NSString *content = self.letterContent.text;
    
    //向数据库添加参数字典
    NSMutableDictionary *mailsDic=[NSMutableDictionary dictionaryWithCapacity:(5)];
    [mailsDic setValue:box_id forKey:@"box_id"];
    [mailsDic setValue:user_id forKey:@"user_id"];
    [mailsDic setValue:send_time forKey:@"send_time"];
    [mailsDic setValue:receive_time forKey:@"receive_time"];
    [mailsDic setValue:subject forKey:@"subject"];
    [mailsDic setValue:content forKey:@"content"];
    [mailsDic setValue:imageString forKey:@"send_file_name"];
    
    //Sqlite3Util *sqlutil = [[Sqlite3Util alloc]init];
    [sqlUtil insertTable:@"mailbox" withArgs:mailsDic];
    NSLog(@"%@",receive_time);
    NSLog(@"%@",self.letterTitle.text);
    NSLog(@"%@",self.letterContent.text);
    
    UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完毕!" delegate:self cancelButtonTitle:@"再写一封" otherButtonTitles:@"去收件箱", nil];
    [nameAlertView show];
}
//点击空白处隐藏软键盘
- (IBAction)tapDaown:(id)sender {
    [self.letterTitle  resignFirstResponder];
    [ self.letterContent  resignFirstResponder];
}

//从相册添加img
- (IBAction)chooseBackgruandImage:(id)sender {
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    //picker.view.frame = CGRectMake(0, 0, 298, 269);
    imagepicker.allowsEditing = YES;
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagepicker animated:YES completion:nil];
    
}

//使用相机
- (IBAction)UseCamera:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有或未找到相机" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}


//获取图片的委托方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    isFullScreen = NO;
    self.imageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//清空照片
- (IBAction)deletePicture:(id)sender {
    self.imageView.image=nil;
}

// 草稿箱
- (IBAction)saveMessage:(id)sender {
    isFromLogout = 2;
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要保存至草稿吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存并前往草稿箱",nil];
    [tempAlertView show];
    
    tempAlertView = nil;
    
}

- (IBAction)sendmessage:(id)sender {
    [self sentMessage];
}

- (IBAction)tuya:(id)sender {
    [self performSegueWithIdentifier:@"tuya" sender:self];
}

//设置收信日期
- (IBAction)receiveDateSet:(id)sender {
    pickerKind = PICKER_KIND_DATEPICKER;
    // 发信日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"确 定" otherButtonTitles:nil];
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
}


- (IBAction)receiveTimeSet:(id)sender {
    pickerKind =PICKER_KIND_TIMEPICKER;
    // 发信时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"确 定" otherButtonTitles:nil];
    [actionSheet addSubview:timePiker];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (pickerKind == PICKER_KIND_DATEPICKER) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        receiveDate=[dateFormatter stringFromDate:datePicker.date];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *year = [dateFormatter stringFromDate:datePicker.date];
        [dateFormatter setDateFormat:@"MM"];
        NSString *month = [dateFormatter stringFromDate:datePicker.date];
        [dateFormatter setDateFormat:@"dd"];
        NSString *day = [dateFormatter stringFromDate:datePicker.date];
        [self setReceiveDate:year andMonth:month andDay:day ];
        
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HHmm"];
        receiveTime=[dateFormatter stringFromDate:datePicker.date];
        [dateFormatter setDateFormat:@"HH"];
        NSString *hour = [dateFormatter stringFromDate:datePicker.date];
        [dateFormatter setDateFormat:@"mm"];
        NSString *minite = [dateFormatter stringFromDate:datePicker.date];
        [self setReceiveTime:hour andminite:minite ];
    }
}

-(void)setReceiveDate:(NSString *)year andMonth:(NSString *)month andDay:(NSString *)day {
    self.receiveDateGet.text = [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}

-(void)setReceiveTime:(NSString *)hour andminite:(NSString *)minite{
    self.receiveTimeGet.text = [NSString stringWithFormat:@"%@时%@分",hour,minite];
}

-(void)touchesBegan:(UIEvent *)event
{
    if (!self.imageView.image) {
        return;
    }
    int i = [self.imageView.subviews indexOfObject:self.imageView];
    [self.imageView.superview exchangeSubviewAtIndex:i withSubviewAtIndex:i+1];
    isFullScreen = !isFullScreen;
    // 设置图片放大动画
    [UIView beginAnimations:nil context:nil];
    // 动画时间
    [UIView setAnimationDuration:1];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    if (isFullScreen) {
        // 放大尺寸
        self.imageView.frame = CGRectMake(0, 0, width, height);
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        // 缩小尺寸
        self.imageView.frame = CGRectMake(190, 243, 104, 121);
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    // commit动画
    [UIView commitAnimations];
    
}

@end
