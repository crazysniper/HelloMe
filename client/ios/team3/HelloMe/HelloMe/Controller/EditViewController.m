//
//  EditViewController.m
//  HelloMe
//
//  Created by Eva.yuanzi on 2013/12/16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "EditViewController.h"
#import "CustomPicker.h"
#import "NSDateExtras.h"
#import "ImagePickerManager.h"
#import "SendMailNetwork.h"
#import "MailDTO.h"
#import "KeychainAccessor.h"
#import "EmailLogic.h"
#import "CustomUIAlertView.h"
#import "AlertViewManager.h"

@interface EditViewController (){
   
    // actionSheet区分flag
    BOOL flag ;
    //图片2进制路径
    NSString* filePath;
    // 预计收信时间
    NSString *receiveTime;
    // 显示缩略图片附件
    UIImageView *smallimage;
    NSString*buffer;
    UIPanGestureRecognizer *swipeGesture;
    
    }
@property UITextView *mytextView;


@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"开始");
    // back Button设置
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 25.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // titleView设置底线
    CALayer *bottom = [CALayer layer];
    float height = _titleView.frame.size.height;
    //float width = _btnView.frame.size.width;
    bottom.frame= CGRectMake(0.0f, height, 320, 2.0f);
    bottom.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
    //  CGSize evaheight = self.mytextView.contentSize;
    self.mytextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 140, 300,200)];
   // self.mytextView.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:self.mytextView];
    
    [_titleView.layer addSublayer:bottom];
    // 附件 tap 手势
    swipeGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeGesture.delegate = self;
    [self.mytextView addGestureRecognizer:swipeGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    [self.mytextView addGestureRecognizer:tap];
    
    
    // 输入区域长按添加图片
    UIMenuItem *addPhoto = [[UIMenuItem alloc] initWithTitle:@"添加图片" action:@selector(addphoto)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:addPhoto, nil]];
    [menu setTargetRect:_mytextView.frame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
    
    smallimage = [[UIImageView alloc] initWithFrame:
                  CGRectMake(10, 340, 50, 50)];
    [self.view addSubview:smallimage];
    if ([self.drafttoEdit isEqualToString:@"drafttoEdit"]) {
        [self draftMailInfo: self.mailDto];
        self.title = @"编辑草稿";
    }
    // 图片初始化
    buffer = @"/null/ul";

}
// 拖动手势隐藏键盘
-(void)swipeGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    NSLog(@"隐藏键盘");
 
    [self.mytextView resignFirstResponder];
    swipeGesture.enabled = NO;
   
    self.mytextView.frame = CGRectMake(10, 140, 300,360);
    smallimage.frame = CGRectMake(10, 500, 50, 50);
    
 
}
-(void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer{
    [self.mytextView becomeFirstResponder];
    swipeGesture.enabled = YES;
    self.mytextView.frame = CGRectMake(10, 140, 300,200);
    smallimage.frame = CGRectMake(10, 340, 50, 50);
}

- (void)viewWillUnload {
    NSLog(@"viewWillUnload");
}
- (void)viewDidUnload{
     NSLog(@"viewDidUnload");
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
}
- (BOOL)canBecomeFirstResponder{
    
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [super canPerformAction:action withSender:sender];
    
    if ( action == @selector(addphoto))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)addphoto{
    NSLog(@"then,you can carry a photo with this mail~");
    // 隐藏键盘
    if ([self.Theme isEditing]) {
            [self.Theme resignFirstResponder];
    }else{
    [self.mytextView resignFirstResponder];
    }
    // 弹出打开相机、相册选择菜单
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                           delegate:self
                                                           cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:@"从相册选择"
                                                        otherButtonTitles:@"拍照上传", nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [photoActionSheet showInView:self.view];
    
    flag = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"结束");
    // Dispose of any resources that can be recreated.
}

- (void)sendNetworkError{
    NSLog(@"ss");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (void)sendSuccessd{
    [AlertViewManager showAlertWithTitle :@"提示" message:@"发送成功"  onButtonClicked:^(int buttonIndex) {
        // 发送成功 关闭当前页面
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"alertViewCancel");
    }];
    
}
- (void)sendFailed{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

// send mail Button
- (IBAction)sendmail:(id)sender {
    SendMailNetwork *send = [[SendMailNetwork alloc]init];
    MailDTO *dto = [[MailDTO alloc]init];
    send.delegate = self;
    
    dto.sendTime    = [[NSDate now] stringFormat:@"yyyyMMddHHmm"];
    dto.receiveTime = receiveTime;
    dto.subject     = self.Theme.text;
    dto.text        = self.mytextView.text;
    dto.sendFileName= @"team3-image";
    dto.image = buffer;
    dto.userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
    [send saveMail:dto];
    
        if (dto!= nil) {
        NSLog(@"data is available,sendtime = %@ %@ %@",[[NSDate now] stringFormat:@"yyyyMMddHHmm"],dto.subject,dto.receiveTime);
    }
}
// 弹出日期选择器
- (IBAction)selecttime:(id)sender {
 //   UIDatePicker *mypicker = [[UIDatePicker alloc]init];
   // UIDatePickerModeDateAndTime *mypicker = [[UIDatePickerModeDateAndTime alloc]init];
   
   [CustomPicker showDatePickWithDelegate:self selectedDate:[NSDate now] okButtonPressed:^(id retValue) {
       
       NSString *time =[retValue stringFormat:@"yyyyMMdd"];
       receiveTime =[retValue stringFormat:@"yyyyMMdd"];
       [CustomPicker showMinSecDatePickWithDelegate:self selectedDate:1 okButtonPressed:^(id retValue) {
           
           NSString *time2 = [NSString stringWithFormat:@"%@%@",time,retValue ];
           NSLog(@"%@",time2);

           receiveTime =time2;
           self.SupposedTime.text = time2;
       }];
       
   }];
}

// cancel按钮
- (void)cancelBtn {
  
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"删除草稿"
                                      otherButtonTitles:@"保存草稿",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    flag = NO;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // addPhoto Button actionSheet
    if (flag == YES) {
        NSLog(@"here is longtouch action，the flag = %@",flag?@"YES":@"NO");
        if (buttonIndex == 0) {
            NSLog(@"从本地相册选择图片");
            [self localPhoto];
        }else if (buttonIndex == 1){
            NSLog(@"打开照相机");
            [self takePhoto];
        
        }else if(buttonIndex == 2) {
            NSLog(@"取消，返回编辑页面，buttonIndex = %ld",(long)buttonIndex);
        }
    }else{
  // Cancel Button actionSheet
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        
        NSLog(@"删除草稿，返回上一页面，buttonIndex = %ld",(long)buttonIndex);
        
    }else if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
        MailDTO *dto = [[MailDTO alloc]init];
        dto.receiveTime = receiveTime;
        dto.subject     = self.Theme.text;
        dto.text        = self.mytextView.text;
        dto.boxId       = EMAILBOX_ID_CAOGAO;
        //根据保存草稿时间实现删除
        dto.sendTime    = [[NSDate now] stringFormat:@"yyyyMMddHHmm"];
        dto.sendFileName= @"team3-image";
        dto.image = buffer;
        dto.userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
        [EmailLogic addMailInfoTOLoaclDB:dto];
        
        
        NSLog(@"保存草稿，返回上一页面，buttonIndex = %ld",(long)buttonIndex);
       
    }else if(buttonIndex == 2) {
        NSLog(@"取消，返回编辑页面，buttonIndex = %ld",(long)buttonIndex);
          }
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{}];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)localPhoto
{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    
//    //设置选择后的图片可被编辑
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:^{}];
    
    
    
    //创建一个选择后图片的小图标放在下方,类似微薄选择图后的效果
    [ImagePickerManager showImagePickerOnTarget:self imageSelected:^(UIImage *image) {
        //  NSData *imageDate = UIImageJPEGRepresentation(image, 0.7);
        smallimage.image = image;
        NSData *imageData=UIImageJPEGRepresentation(image,1.0f);
        buffer=[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }];
}


//// 选择图片之后的 处理
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    // 当前选择的类型是图片
//    if ([type isEqualToString:@"public.image"]) {
//        
//        //把图片转换成NSData
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil) {
//            data = UIImageJPEGRepresentation(image,1.0);
//        }else{
//            data = UIImagePNGRepresentation(image);
//        }
//    // 图片保存路径，这里将图片保存在沙盒的documents文件夹中
//        
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//      
//        //得到选择后沙盒中图片的完整路径
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//        //关闭相册界面
//        [picker dismissViewControllerAnimated:YES completion:^{}];
//    
//        //创建一个选择后图片的小图标放在下方,类似微薄选择图后的效果
//        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
//                                    CGRectMake(10, 500, 40, 40)];
//        smallimage.image = image;
//        //加在视图中
//        [self.view addSubview:smallimage];
//        NSLog(@"图片的路径是：%@", filePath);
//    
//    }
//}

// 草稿箱迁入初始化
// 显示邮件内容
-(void)draftMailInfo:(MailDTO*)mail{
    // 设置mail Title
    self.Theme.text = mail.subject;
    self.SupposedTime.text = mail.receiveTime;
    self.mytextView.text = mail.text;
    
    
    if ([mail.image isEqualToString:@"/null/ul"]) {
        smallimage.hidden = YES;
    }else{
    
    //解密
    NSData *imgData=[[NSData alloc]initWithBase64EncodedString:mail.image options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image=[UIImage imageWithData:imgData];
    smallimage.image = image;

    }
   self.Theme.textColor = [UIColor brownColor];

   // [self displayAttachment];
}
@end
