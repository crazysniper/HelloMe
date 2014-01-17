//
//  ReadViewController.m
//  HelloMeTeam1
//
//  Created by wuhh on 12/18/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "DetailViewController.h"
#import "Message.h"
#import "Define.h"
#import "TabBarViewController.h"

@interface DetailViewController (){
    BOOL isFullScreen;
}

@end

@implementation DetailViewController

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
    [self.attachImg addGestureRecognizer:singleTap];
    self.attachImg.userInteractionEnabled = YES;
    
    //写入scrollerview内容
    self.msgText.scrollEnabled=YES;
    self.msgText.delegate=self;
    self.msgText.bounces=NO;
    self.msgText.contentSize=self.msgText.frame.size;
    //显示邮件内容
    [self showMsg:self.messageDetail];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(UIEvent *)event
{
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~");
    int i = [self.view.subviews indexOfObject:self.attachImg];
    [self.attachImg.superview exchangeSubviewAtIndex:i withSubviewAtIndex:i+2];
    isFullScreen = !isFullScreen;
    // 设置图片放大动画
    [UIView beginAnimations:nil context:nil];
    // 动画时间
    [UIView setAnimationDuration:1];
    
    if (isFullScreen) {
        // 放大尺寸
        
        self.attachImg.frame = CGRectMake(0, 0, 320, 480);
    }
    else {
        // 缩小尺寸
        self.attachImg.frame = CGRectMake(20, 285, 103, 147);
    }
    
    // commit动画
    [UIView commitAnimations];
    
}

-(void) showMsg:(Message *)msg{
    NSString * strSendYear = msg.sendYear;
    NSString * strSendMonth = msg.sendMonth;
    NSString * strSendDay = msg.sendDay;
    NSString * strSendHour = msg.sendHour;
    NSString * strSendMinute = msg.sendMinute;
    NSString * strReceiveYear = msg.receiveYear;
    NSString * strReceiveMonth = msg.receiveMonth;
    NSString * strReceiveDay = msg.receiveDay;
    NSString * strReceiveHour = msg.receiveHour;
    NSString * strReceiveMinute = msg.receiveMinute;
    self.msgTopic.text = msg.topic;
    UITextView *tv=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 186, 176)];
    tv.text=msg.text;
    
    // 接受发信时间并且format
    NSString *strSendTime = sNoValue;
    if (strSendYear.length == 0) {
        strSendTime = sSendTimeIsNull;
    } else{
        strSendTime = [NSString stringWithFormat:@"%@年%@月%@日%@点%@分",strSendYear,strSendMonth,strSendDay,strSendHour,strSendMinute];
    }
    self.sendTime.text = strSendTime;
    
    // 接受收信时间并且format
    NSString *strReceiveTime = sNoValue;
    if (strReceiveYear.length == 0) {
        strReceiveTime = sReceiveTimeIsNull;
    }else{
        strReceiveTime = [NSString stringWithFormat:@"%@年%@月%@日%@点%@分",strReceiveYear,strReceiveMonth,strReceiveDay,strReceiveHour,strReceiveMinute];
    }
    self.receiveTime.text = strReceiveTime;
    
    // 从db检索图片信息
    NSString *searchFullpath = nil;
    NSString *searchImageString = nil;
    NSString *searchImageName = nil;
    searchFullpath = msg.sendFileUrl;
    searchImageString = msg.sendImageString;
    searchImageName = msg.sendImageName;
    NSLog(@"%@111111111",msg.sendImageString);
    NSLog(@"%@222222222",msg.sendImageName);
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:searchFullpath];
    [self.attachImg setImage:savedImage];

    if (!searchImageString.length==0) {
        // 获取沙盒目录
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:searchImageName];
        NSData*imgData=[[NSData alloc]initWithBase64EncodedString:searchImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *searchImage=[UIImage imageWithData:imgData];
        // 将图片写入文件
        [imgData writeToFile:fullPath atomically:NO];
        [self.attachImg setImage:searchImage];
        
    }
    
    [tv setEditable:NO];
    [self.msgText addSubview:tv];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarViewController *viewController = (TabBarViewController*)segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"gotoTabBar"]) {
        if ([_boxId isEqualToString:@"1"]) {
            //goToInbox
            [viewController setSelectedIndex:0];
        }else if ([_boxId isEqualToString:@"1"]) {
            //goToTrash
            [viewController setSelectedIndex:2];
        }
    }
}


@end
