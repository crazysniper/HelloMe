//
//  DraftViewController.m
//  HelloMeTeam1
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import "DraftViewController.h"
#import "DraftCell.h"
#import "HelloMeViewController.h"
#import "Message.h"
#import "MessageService.h"
#import "String.h"
#import "HelloMeViewController.h"
#import "MySingleton.h"

@interface DraftViewController ()
{
    NSMutableArray *_dataArray;
}

@end

@implementation DraftViewController

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

    NSLog(@"~~~~~~~~~网络中断查看本地信息 ~~~~~~~~~");
    //set draft count
    MessageService *service2 = [[MessageService alloc]init];
    _draftCount.text = [service2 getCountWithDivision:@"2"];

    // 草稿箱明细一览画面的数据取得
    MessageService *service = [[MessageService alloc]init];
    self.messageArrayforDraft = [service getProfileInfoWithDivision:sDraftDivision];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

//返回分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArrayforDraft count];
}

// 一览画面明细行明细数据出力
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DraftCell";
	
	DraftCell *draftCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (draftCell == nil) {
		draftCell = [[DraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    // 初始化代码
    [draftCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Message *messageforTrashInfo = (Message *)[_messageArrayforDraft objectAtIndex:[indexPath row]];
    draftCell.draftTitle.text = messageforTrashInfo.topic;
    if(messageforTrashInfo.sendImageString.length != 0){
        draftCell.attachmentImg.image=[UIImage imageNamed:@"附件.png"];
    }
    return draftCell;
}

//画面传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"开始传值");
    if([segue.identifier isEqualToString:@"draftDetail"]){
        HelloMeViewController  *draftDetail=(HelloMeViewController*)segue.destinationViewController;
        draftDetail.messageEditDetail=_messageDraft;
        draftDetail.Dbflg=@"Edit";
    }
}

//画面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"开始跳转");
    _messageDraft=[_messageArrayforDraft objectAtIndex:(indexPath.row)];
    [self performSegueWithIdentifier:@"draftDetail" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _messageDraft=[_messageArrayforDraft objectAtIndex:(indexPath.row)];
        NSLog(@"AAAAAAAAAAAid:%@",_messageDraft.messageID);
        //db motify
        MessageService *service = [[MessageService alloc]init];
        [service motifyMessageInfo:_messageDraft.messageID];
        
        [_messageArrayforDraft removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //set draft count
        MessageService *service2 = [[MessageService alloc]init];
        _draftCount.text = [service2 getCountWithDivision:@"2"];
    }
}@end