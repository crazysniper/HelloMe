//
//  RabbishBoxViewControlViewController.m
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "RabbishBoxViewControlViewController.h"
#import "RabbishCell.h"
#import "Sqlite3Util.h"
#import "AppDelegate.h"

@interface RabbishBoxViewControlViewController (){
    Sqlite3Util *sqlUtil;
    // 创建用于接收从回收箱取得的信件
    NSMutableDictionary *rabbishMailBoxDic;
    // 保存所有Key
    NSMutableArray *allKey;
    // 保存所有value
    NSMutableArray *allValue;
    // plist的data
    NSMutableDictionary *data;
    // 点击全部还原按钮后的data数
    int dataReceieveCnt;
}

@end

@implementation RabbishBoxViewControlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 初始化处理
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 数据库初始化
    sqlUtil = [[Sqlite3Util alloc]init];
    [sqlUtil initDataBase];
    [sqlUtil createTables];
    
    // 获取用户名
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.loginUserName.text =appDelegate.kUserName;
    
    // 获取所有回收信件
    [self recieveRabbishMessagesInit];
    
    // 动态添加按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"还原" style:UIBarButtonItemStyleBordered target:self action:@selector(returnAllMessages)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(didLogout)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boxbgimg3.jpg"]];
    self.myRabbishTableView.backgroundView = view;
    [self.myRabbishTableView setSectionIndexColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    // 获取所有回收信件
    [self recieveRabbishMessagesInit];
    
    [_myRabbishTableView reloadData];
    
}

- (void) recieveRabbishMessagesInit{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // 获取信件的列表
    rabbishMailBoxDic = [sqlUtil selectMailBox:appDelegate.kUserName withReceiveTime:nil withBoxId:@"2"];
    allKey =[[NSMutableArray alloc]init];
    allValue =[[NSMutableArray alloc]init];
    [allKey setArray:[rabbishMailBoxDic allKeys]];
    [allValue setArray:[rabbishMailBoxDic allValues]];
}

// 全部还原信件处理
-(void)returnAllMessages{
    
    // 将所有回收信件还原成非回收信件
    NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
    [args setValue:@"1" forKey:@"box_id"];
    [args setValue:self.loginUserName.text forKey:@"user_id"];
    [args setValue:@"YES" forKey:@"isAll"];
    
    [sqlUtil deleteTable:@"mailbox" withArgs:args];
    
    [rabbishMailBoxDic removeAllObjects];
    
    // 重新加载数据
    [_myRabbishTableView reloadData];
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

- (void)viewDidUnload {
    // 关闭数据库
    [sqlUtil closeDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sort{
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
    return rabbishMailBoxDic.count;
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
    static NSString *cellIdentifier = @"RabbishCell";
    RabbishCell *rabbishCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (rabbishCell == nil) {
        rabbishCell = [[RabbishCell alloc]
                      initWithStyle:UITableViewCellStyleDefault
                      reuseIdentifier: cellIdentifier];
    }
    
    // 不可以被点击
    rabbishCell.selectionStyle = UITableViewCellSelectionStyleNone;

    // 冒泡排序
    [self sort];
    
    if(![[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"send_file_name"] isEqualToString:@""]){
        rabbishCell.pngImage.image = [UIImage imageNamed:@"fujian.jpg"];
    }
    
    rabbishCell.title.text  = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"subject"];
    NSString *dayTemp = [[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"receive_time"] substringWithRange:NSMakeRange(6, 2)];
    
    if([[dayTemp substringToIndex:1] isEqualToString:@"0"] ){
        rabbishCell.day.text = [[dayTemp substringFromIndex:1] stringByAppendingString:@"日"];
    }else{
        rabbishCell.day.text = [dayTemp stringByAppendingString:@"日"];
    }
    
    rabbishCell.mailid.text = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
    
    return rabbishCell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [allKey objectAtIndex:indexPath.section];
        // 获取删除的mail_id
        NSString *mailId = [[[rabbishMailBoxDic valueForKey:key] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
        
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setValue:@"1" forKey:@"box_id"];
        [args setValue:self.loginUserName.text forKey:@"user_id"];
        [args setValue:mailId forKey:@"mail_id"];
        [sqlUtil deleteTable:@"mailbox" withArgs:args];
        
        [[rabbishMailBoxDic valueForKey:key] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"还原";
}

@end
