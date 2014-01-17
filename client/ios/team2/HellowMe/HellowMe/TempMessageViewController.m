//
//  TempMessageViewController.m
//  HellowMe
//
//  Created by Smartphone18 on 13-12-23.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "TempMessageViewController.h"
#import "Sqlite3Util.h"
#import "AppDelegate.h"
#import "TempCell.h"
#import "SendMessageViewControl.h"
#import "TabBarViewController.h"

@interface TempMessageViewController (){
    Sqlite3Util *sqlUtil;
    // 创建用于接收从草稿箱取得的信件
    NSMutableDictionary *tempMailBoxDic;
    // 保存所有Key
    NSMutableArray *allKey;
    // 保存所有value
    NSMutableArray *allValue;
    // plist的data
    NSMutableDictionary *data;
    // 点击全部还原按钮后的data数
    int dataReceieveCnt;
    // 选中的mailid
    NSString *mailId;
}

@end

@implementation TempMessageViewController

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
    
    // 数据库初始化
    sqlUtil = [[Sqlite3Util alloc]init];
    [sqlUtil initDataBase];
    [sqlUtil createTables];
    
    // 获取用户名
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.loginUserName.text =appDelegate.kUserName;
    
    // 获取所有草稿信件
    [self recieveTempMessagesInit];
    
    // 动态添加按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllTemps)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(didLogout)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boxbgimg2.jpg"]];
    self.myTempTableView.backgroundView = view;
}

// 清空处理
- (void)deleteAllTemps{
    // 将所有回收信件还原成非回收信件
    NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
    [args setValue:@"3" forKey:@"box_id"];
    [args setValue:self.loginUserName.text forKey:@"user_id"];
    [args setValue:@"YES" forKey:@"isAll"];
    
    [sqlUtil deleteTableTemp:@"mailbox" withArgs:args];
    
    [tempMailBoxDic removeAllObjects];
    
    // 重新加载数据
    [_myTempTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    // 获取所有回收信件
    [self recieveTempMessagesInit];
    
    [_myTempTableView reloadData];
}

- (void) recieveTempMessagesInit{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // 获取信件的列表
    tempMailBoxDic = [sqlUtil selectMailBox:appDelegate.kUserName withReceiveTime:nil withBoxId:@"3"];
    allKey =[[NSMutableArray alloc]init];
    allValue =[[NSMutableArray alloc]init];
    [allKey setArray:[tempMailBoxDic allKeys]];
    [allValue setArray:[tempMailBoxDic allValues]];
}

// 退出按钮
- (void)didLogout{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)sort{
    BOOL bFinish = YES;
    for (int i = 1; i <= allKey.count && bFinish; i++) {
        bFinish = NO;
        for (int j = allKey.count - 1; j >= i; j--) {
            NSString *year1 = [[allKey objectAtIndex:j] substringToIndex:4];
            NSString *month1 = [[allKey objectAtIndex:j] substringWithRange:NSMakeRange(5, 2)];
            NSString *ym1 = [year1 stringByAppendingString:month1];
            NSString *year2 = [[allKey objectAtIndex:j-1] substringToIndex:4];
            NSString *month2 = [[allKey objectAtIndex:j-1] substringWithRange:NSMakeRange(5, 2)];
            NSString *ym2 = [year2 stringByAppendingString:month2];
            if ([ym1 intValue] < [ym2 intValue]){
                [allKey exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
                [allValue exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
                bFinish = YES;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 冒泡排序
    [self sort];
    return [[allValue objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tempMailBoxDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 冒泡排序
    [self sort];
    return [allKey objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TempCell";
    TempCell *tempCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (tempCell == nil) {
        tempCell = [[TempCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: cellIdentifier];
    }
    
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 冒泡排序
    [self sort];
    
    if(![[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"send_file_name"] isEqualToString:@""]){
        tempCell.pngImage.image = [UIImage imageNamed:@"fujian.jpg"];
    }
    
    tempCell.title.text  = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"subject"];
    NSString *dayTemp = [[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"receive_time"] substringWithRange:NSMakeRange(6, 2)];
    
    if([[dayTemp substringToIndex:1] isEqualToString:@"0"] ){
        tempCell.day.text = [[dayTemp substringFromIndex:1] stringByAppendingString:@"日"];
    }else{
        tempCell.day.text = [dayTemp stringByAppendingString:@"日"];
    }
    
    tempCell.mailid.text = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
    
    return tempCell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [allKey objectAtIndex:indexPath.section];
        // 获取删除的mail_id
        NSString *mailId1 = [[[tempMailBoxDic valueForKey:key] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
        
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setValue:@"3" forKey:@"box_id"];
        [args setValue:@"NO" forKey:@"isAll"];
        [args setValue:self.loginUserName.text forKey:@"user_id"];
        [args setValue:mailId1 forKey:@"mail_id"];
        [sqlUtil deleteTableTemp:@"mailbox" withArgs:args];
        
        [[tempMailBoxDic valueForKey:key] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [allKey objectAtIndex:indexPath.section];
    // 获取删除的mail_id
    mailId = [[[tempMailBoxDic valueForKey:key] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
    [self performSegueWithIdentifier:@"templetter" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //goToInbox
    if ([segue.identifier isEqualToString:@"templetter"]) {
        SendMessageViewControl *messagedetail =(SendMessageViewControl *)segue.destinationViewController;
        messagedetail.mailId=mailId;
        messagedetail.isFromTemp = @"YES";
        messagedetail.hidesBottomBarWhenPushed = YES;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
