//
//  TrashViewController.m
//  HelloMeTeam1
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import "TrashViewController.h"
#import "TrashCell.h"
#import "MessageService.h"
#import "TrashViewController.h"
#import "DetailViewController.h"
#import "String.h"
#import "MySingleton.h"

@interface TrashViewController ()
{
    NSMutableArray *_dataArray;
}

@end

@implementation TrashViewController

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
    //set trash count
    MessageService *service3 = [[MessageService alloc]init];
    _trashCount.text = [service3 getCountWithDivision:@"3"];

    // 垃圾箱明细一览画面的数据取得
    MessageService *service = [[MessageService alloc]init];
    self.messageArrayforTrash = [service getProfileInfoWithDivision:sRecoverDivision];

}

#pragma mark - Table View Delegate

//返回分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArrayforTrash count];
}

// 一览画面明细行明细数据出力
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"1111111");
    static NSString *cellIdentifier = @"TrashCell";
	
	TrashCell *trashCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (trashCell == nil) {
		trashCell = [[TrashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    NSLog(@"22222");
    // 初始化代码
    [trashCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Message *messageforTrashInfo = (Message *)[_messageArrayforTrash objectAtIndex:[indexPath row]];
    NSLog(@"333333");
        trashCell.trashTitle.text = messageforTrashInfo.topic;
    if(messageforTrashInfo.sendImageString.length != 0){
        trashCell.attachmentImg.image=[UIImage imageNamed:@"附件.png"];
    }
    return trashCell;
}

//画面传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"开始传值");
    if([segue.identifier isEqualToString:@"trashDetail"]){
        DetailViewController  *trashDetail=(DetailViewController*)segue.destinationViewController;
        trashDetail.boxId=@"3";
        trashDetail.messageDetail=_messageTrash;
        NSLog(@"信息是 %@",trashDetail.messageDetail.topic);
    }
}

//画面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"开始跳转");
    _messageTrash=[_messageArrayforTrash objectAtIndex:(indexPath.row)];
    [self performSegueWithIdentifier:@"trashDetail" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            _messageTrash=[_messageArrayforTrash objectAtIndex:(indexPath.row)];
            NSLog(@"AAAAAAAAAAAid:%@",_messageTrash.messageID);
            //db delete
            MessageService *service = [[MessageService alloc]init];
            [service deleteMessageInfo:_messageTrash.messageID];
            
            [_messageArrayforTrash removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //set draft count
            MessageService *service2 = [[MessageService alloc]init];
            _trashCount.text = [service2 getCountWithDivision:@"3"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 57.0f;
}
@end
