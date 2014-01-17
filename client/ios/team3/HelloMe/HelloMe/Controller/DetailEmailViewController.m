//
//  DetailEmailViewController.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "DetailEmailViewController.h"
#import "MailDTO.h"
#import "MBProgressHUD.h"
#import "AvatarBrowser.h"
#import "NSData+Base64.h"
#import "MRZoomScrollView.h"
#import "DisplayImageView.h"


@interface DetailEmailViewController (){
    float _fontSize;
}

@end

@implementation DetailEmailViewController

@synthesize mailTitle;
@synthesize wroteTime;
@synthesize receiveTime;
@synthesize titleView;

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
	// Do any additional setup after loading the view.
    
    // titleView设置底线
    CALayer *bottom = [CALayer layer];
    float height = titleView.frame.size.height-1.0f;
    float width = titleView.frame.size.width;
    bottom.frame= CGRectMake(0.0f, height, width, 3.0f);
    bottom.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
    [titleView.layer addSublayer:bottom];
    
    //左边navigationItems back 设置
    [self.navigationItem setHidesBackButton:YES];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 25.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //右边navigationItems 设置
    UILabel *labelF = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [labelF setText:@"查阅"];
    labelF.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelF;
    UIButton *menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton1.frame = CGRectMake(0.0f, 10.0f, 25.0f, 15.0f);
    [menuButton1 setBackgroundImage:[UIImage imageNamed:@"inbox_last.png"] forState:UIControlStateNormal];
    [menuButton1 addTarget:self action:@selector(lastBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton *menuButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton2.frame = CGRectMake(0.0f, 0.0f, 25.0f, 15.0f);
    [menuButton2 setBackgroundImage:[UIImage imageNamed:@"inbox_next.png"] forState:UIControlStateNormal];
    [menuButton2 addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items = [[NSArray alloc]initWithObjects:[[UIBarButtonItem alloc]initWithCustomView:menuButton2], [[UIBarButtonItem alloc]initWithCustomView:menuButton1],nil];
    self.navigationItem.rightBarButtonItems = items;
    
    // 设置文本字体大小 初始字体为15号
    _fontSize = 15;
    self.textField.font = [UIFont boldSystemFontOfSize:_fontSize];
    [self.textField setEditable:NO];
    self.textField.bounces = NO;
    
    // 显示邮件内容
    [self mailInfo:self.mailDto fontSizeSet:_fontSize];
    self.changeSlider.value = _fontSize;
    
    // 长按textView 设置
    UIMenuItem *plusFont = [[UIMenuItem alloc] initWithTitle:@"增大字体" action:@selector(plusFontFoundation)];
    UIMenuItem *cutFont = [[UIMenuItem alloc] initWithTitle:@"减小字体" action:@selector(cutFontFoundation)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:plusFont,cutFont,nil]];
    [menu setTargetRect:self.textField.frame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
    
    // 文本 tap 手势 执行缩放字体操作
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didtextViewTapped:)];
    [self.textField addGestureRecognizer:tapGestureRecognizer];
    
    // 右滑返回
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipped:)];
    [self.textField addGestureRecognizer:swipeGestureRecognizer];
    
    // 共通
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 翻阅邮件 下一封
-(void)nextBtn
{
    [self hiddenSlider];
    if (self.index<self.mailList.count-1) {
        self.mailDto = [self.mailList objectAtIndex:(++self.index)];
        [self mailInfo:self.mailDto fontSizeSet:_fontSize];
    }else if(self.index == self.mailList.count-1){
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kuface.png"]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"已是最后一封邮件";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}

// slider 改变字体大小
- (IBAction)changFont:(id)sender {
    
    _fontSize = roundf(self.changeSlider.value);
    NSLog(@"%f=======font",_fontSize);
    self.textField.font = [UIFont boldSystemFontOfSize:_fontSize];
}
// 翻阅邮件 上一封
-(void)lastBtn
{
    [self hiddenSlider];
    if(self.index == 0){
        // 显示提示信息
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kuface.png"]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"已是第一封邮件";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }else if (self.index>0) {
        self.mailDto = [self.mailList objectAtIndex:(--self.index)];
        [self mailInfo:self.mailDto fontSizeSet:_fontSize];
    }
}
// 显示邮件内容
-(void)mailInfo:(MailDTO*)mail fontSizeSet:(float)sizeSet{
    // 设置mail Title
    NSString *wroteStr = @"写信时间: ";
    NSString *receiveStr = @"收信时间: ";
    mailTitle.text = mail.subject;
    mailTitle.font = [UIFont boldSystemFontOfSize:30];
    mailTitle.textColor = [UIColor brownColor];
    wroteTime.text = [NSString stringWithFormat:@"%@%@",wroteStr,mail.sendTime];
    wroteTime.font = [UIFont boldSystemFontOfSize:14];
    receiveTime.text = [NSString stringWithFormat:@"%@%@",receiveStr,mail.receiveTime];
    receiveTime.font = [UIFont boldSystemFontOfSize:14];
    self.textField.text = mail.text;
    self.textField.font = [UIFont boldSystemFontOfSize:sizeSet];
    NSLog(@"%f=======mailInfoFont",sizeSet);
    [self displayAttachment];
}

// 增加字体 每次加2号字体
- (void)plusFontFoundation{
    NSLog(@" plus ");
    [self mailInfo:self.mailDto fontSizeSet:(++_fontSize)];
}

// 减小字体 每次减2号字体
-(void)cutFontFoundation{
    NSLog(@" minus ");
    [self mailInfo:self.mailDto fontSizeSet:(--_fontSize)];
}

// 点击手势tap 执行该方法 显示slider 调节字体
- (void)didtextViewTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    if (self.changeSlider.hidden) {
        self.changeSlider.hidden = NO;
        NSLog(@"swith===NO");
    }else{
        self.changeSlider.hidden = YES;
        NSLog(@"swith===YES");
    }
    NSLog(@"textTapped");
}

// 点击image执行该方法 查看大图
- (void)didImageViewTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    NSLog(@"imageTapped");
    [self hiddenSlider];
    //解密
    NSData* imgData=[[NSData alloc]initWithBase64EncodedString:_mailDto.image options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image=[UIImage imageWithData:imgData];
    DisplayImageView *scaImage = [[DisplayImageView alloc]init];
    scaImage.image = image;
    [self presentViewController:scaImage animated:YES completion:nil];
    //[self presentModalViewController:scaImage animated:YES];
    
    // self.fujianImage.image = [UIImage imageNamed:@"fujian.png"];
}

// 显示附件 _image	__NSCFString *	@"/null/ul"
- (void) displayAttachment{
    if ([self.mailDto.image isEqualToString:@"/null/ul"]) {
        self.btnAttach.hidden = YES;
        self.fujianLabel.text = @"";
        NSLog(@"fffffffff");
    }else{
        self.btnAttach.hidden = NO;
        self.fujianLabel.text = @"查看附件";
        NSLog(@"ddddddd");
    }
}
// 关闭slider
- (void)hiddenSlider{
    if (!self.changeSlider.hidden) {
        self.changeSlider.hidden = YES;
        NSLog(@"hiddenSlider");
    }
}
// 右滑 返回
- (void)didSwipped:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        //NSLog(@"UISwipeGestureRecognizerDirectionRight");
        [self backAction];
    }
}

- (IBAction)display:(id)sender {
    NSLog(@"imageTapped");
    [self hiddenSlider];
    [self performSegueWithIdentifier:@"display" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"display"]){
        DisplayImageView *scaImage = (DisplayImageView*)segue.destinationViewController;
        //解密
        NSData* imgData=[[NSData alloc]initWithBase64EncodedString:_mailDto.image options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image=[UIImage imageWithData:imgData];
        scaImage.image = image;
    }
}
@end
