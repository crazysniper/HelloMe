//
//  MessageDetailViewController.m
//  HellowMe
//
//  Created by System Administrator on 12/20/13.
//  Copyright (c) 2013 Smartphone18. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Sqlite3Util.h"
#import "AppDelegate.h"
#import "Photo.h"

@interface MessageDetailViewController (){
    Sqlite3Util *sqlUtil;
    // 创建用于接收从收信箱取得的信件
    NSMutableDictionary *mailsDic;}

@end

@implementation MessageDetailViewController

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
    
    self.detailview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boxbgimg3.jpg"]];
    
    sqlUtil = [[Sqlite3Util alloc]init];
    [sqlUtil initDataBase];
    [sqlUtil createTables];
    NSLog(@"%@",self.mailId) ;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    mailsDic = [sqlUtil selectMail:appDelegate.kUserName WithMailId:self.mailId withBoxId:@"1"];
    self.messageTitle.text=[mailsDic valueForKey:@"subject"];
    self.messageContent.editable=NO;
    self.messageContent.text=[mailsDic valueForKey:@"content"];
    [self setReceiveDate:[mailsDic valueForKey:@"send_time"]];
    NSString *imageString=[mailsDic valueForKey:@"send_file_name"];
//    NSLog(@"%@图片",imageString);
    //如果imgerView有图片
    if (![imageString isEqualToString:@""]) {
		NSLog(@"选择UIImageView中的照片");
      //   self.image.image=[UIImage imageNamed:@"Default.png"];
        self.image.image=[Photo string2Image:imageString];
         NSLog(@"图片解码完成");
		//NSLog(@"%@图片编码值",imageString);
	}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setReceiveDate:(NSString *)time{
    
    NSString *year = [[time substringToIndex:4]stringByAppendingString:@"年"] ;
    NSString *month = [[time substringWithRange:NSMakeRange(4,2)]stringByAppendingString:@"月"];
    NSString *day = [[time substringWithRange:NSMakeRange(6,2)]stringByAppendingString:@"日"];
    NSString *hour = [[time substringWithRange:NSMakeRange(8,2)]stringByAppendingString:@"时"];
    NSString *minite = [[time substringWithRange:NSMakeRange(10,2)]stringByAppendingString:@"分"];
    NSString *setTime=[[[[year stringByAppendingString:month]stringByAppendingString:day]stringByAppendingString:hour]stringByAppendingString:minite];
    self.setTime.text = setTime;

}

@end
