//
//  InboxViewController.m
//  HelloMeTeam1
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import "InboxViewController.h"
#import "InboxCell.h"
#import "DetailViewController.h"
#import "Message.h"
#import "MessageService.h"
#import "String.h"
#import "MySingleton.h"

@interface InboxViewController ()
{
    NSMutableArray *_messageList;
}

@end

@implementation InboxViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //网络中断查看本地信息
    NSLog(@"~~~~~~~~~网络中断查看本地信息 ~~~~~~~~~");
    //set inbox count
    MessageService *service1 = [[MessageService alloc]init];
    _inboxCount.text = [service1 getCountWithDivision:@"1"];

    // 收件箱明细一览画面的数据取得
    MessageService *service = [[MessageService alloc]init];
    self.messageArrayforInbox = [service getProfileInfoWithDivision:sReceiveDivision];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Delegate

//返回分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArrayforInbox count];
}

// 一览画面明细行明细数据出力
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InboxCell";
	
	InboxCell *inboxCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (inboxCell == nil) {
		inboxCell = [[InboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    // 初始化代码
    [inboxCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Message *messageforTrashInfo = (Message *)[_messageArrayforInbox objectAtIndex:[indexPath row]];
    inboxCell.inboxTitle.text = messageforTrashInfo.topic;
    if(messageforTrashInfo.sendImageString.length != 0){
        inboxCell.attachmentImg.image=[UIImage imageNamed:@"附件.png"];
    }
    return inboxCell;
}

//画面传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"开始传值");
    if([segue.identifier isEqualToString:@"inboxDetail"]){
        DetailViewController  *inboxDetail=(DetailViewController*)segue.destinationViewController;
        inboxDetail.boxId=@"1";
        inboxDetail.messageDetail=_messageInbox;
        NSLog(@"信息是 %@",inboxDetail.messageDetail.receiveYear);
    }
}

//画面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"开始跳转");
    _messageInbox=[_messageArrayforInbox objectAtIndex:(indexPath.row)];
    [self performSegueWithIdentifier:@"inboxDetail" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
