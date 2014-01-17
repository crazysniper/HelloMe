//
//  ReceiveMessageViewController.m
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "ReceiveMessageViewController.h"
#import "CustomCell.h"
#import "Sqlite3Util.h"
#import "MessageDetailViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

BOOL isInit = YES;

@interface ReceiveMessageViewController (){
    Sqlite3Util *sqlUtil;
    // 创建用于接收从收信箱取得的信件
    NSMutableDictionary *mailBoxDic;
    // 保存所有Key
    NSMutableArray *allKey;
    // 保存所有value
    NSMutableArray *allValue;
    // plist的data
    NSMutableDictionary *data;
    // 点击收取信件按钮后的data数
    int dataReceieveCnt;
    // 画面初期表示时的data数
    int dataInitCnt;
    //邮件id
    NSString *detailMailId;
}

@end

@implementation ReceiveMessageViewController

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
    // 数据库初始化
    sqlUtil = [[Sqlite3Util alloc]init];
    [sqlUtil initDataBase];
    [sqlUtil createTables];
    
    // 读取plist
    // 获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    // 得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"setting.plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    // 获取上次收取信件的时间
    NSString *prevReceieveTime = [data valueForKey:@"tempReceveTime"];
    if (prevReceieveTime != nil && prevReceieveTime.length > 0) {
        [self recieveMessagesInit:prevReceieveTime];
    }else{
        // 首次登陆应用无邮件
        [self recieveMessagesInit:@"000000000000"];
    }
    
    if(isInit){
        // 画面初期表示时的data数
        dataInitCnt = [self getTotalCnt];
    }
    
    // 获取用户名
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.loginUserName.text =appDelegate.kUserName;
    
    // 动态添加按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"收信" style:UIBarButtonItemStyleBordered target:self action:@selector(receiveMessages)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(didLogout)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boxbgimg1.jpg"]];
    self.myTableView.backgroundView = view;
}

- (void) recieveMessagesInit:(NSString *)recieveTime{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // 获取信件的列表
    mailBoxDic = [sqlUtil selectMailBox:appDelegate.kUserName withReceiveTime:recieveTime withBoxId:@"1"];
    allKey =[[NSMutableArray alloc]init];
    allValue =[[NSMutableArray alloc]init];
    [allKey setArray:[mailBoxDic allKeys]];
    [allValue setArray:[mailBoxDic allValues]];
}

// 收取信件处理
- (void) receiveMessages {
    isInit = NO;
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    // 设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMddHHmm"];
    NSString * crrentTime = [df stringFromDate:currentDate];
    
    [self recieveMessagesInit:crrentTime];
    
    // 将本次获取信件的时间保存至plist文件中
    [data setValue:crrentTime forKey:@"tempReceveTime"];
    
    dataReceieveCnt = [self getTotalCnt];
    
    if(!isInit){
        if(dataReceieveCnt == dataInitCnt){
            UIAlertView *noMessageAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到新的信件!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [noMessageAlertView show];
        }else{
            UIAlertView *noMessageAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"获取到%d封新信件!",(dataReceieveCnt - dataInitCnt)]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [noMessageAlertView show];
        }
    }

    dataInitCnt = [self getTotalCnt];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"setting.plist"];
    
    if(data == nil){
        data = [[NSMutableDictionary alloc] init];
    }
    [data writeToFile:filename atomically:YES];
    
    [_myTableView reloadData];

}

// 计算总的信件数
-(int) getTotalCnt{
    int result = 0;
    for (NSMutableArray *object in allValue) {
        result = result + object.count;
    }
    return result;
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
        isInit = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // 关闭数据库
    [sqlUtil closeDB];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 冒泡排序
    [self sort];
    return [allKey objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 冒泡排序
    [self sort];
    return [[allValue objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return mailBoxDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomCell";
    CustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (customCell == nil) {
        customCell = [[CustomCell alloc]
                      initWithStyle:UITableViewCellStyleDefault
                      reuseIdentifier: cellIdentifier];
    }
    
    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 冒泡排序
    [self sort];
    
    if(![[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"send_file_name"] isEqualToString:@""]){
        customCell.pngImage.image = [UIImage imageNamed:@"fujian.jpg"];
    }
    
    customCell.title.text = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"subject"];
    NSString *dayTemp = [[[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"receive_time"] substringWithRange:NSMakeRange(6, 2)];
    
    if([[dayTemp substringToIndex:1] isEqualToString:@"0"] ){
        customCell.day.text = [[dayTemp substringFromIndex:1] stringByAppendingString:@"日"];
    }else{
        customCell.day.text = [dayTemp stringByAppendingString:@"日"];
    }
    
    customCell.mailid.text = [[[allValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [allKey objectAtIndex:indexPath.section];
    detailMailId=[[[mailBoxDic valueForKey:key] objectAtIndex:indexPath.row]valueForKey:@"mail_id"];
    [self performSegueWithIdentifier:@"letterdetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"letterdetail"]) {
        MessageDetailViewController *messagedetail =(MessageDetailViewController *)segue.destinationViewController;
        messagedetail.mailId=detailMailId;
    }
}

// 修改滑动删除的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [allKey objectAtIndex:indexPath.section];
        // 获取删除的mail_id
        NSString *mailId = [[[mailBoxDic valueForKey:key] objectAtIndex:indexPath.row] valueForKey:@"mail_id"];
        
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setValue:@"2" forKey:@"box_id"];
        [args setValue:mailId forKey:@"mail_id"];
        [args setValue:self.loginUserName.text forKey:@"user_id"];
        [args setValue:@"NO" forKey:@"isAll"];
        [sqlUtil deleteTable:@"mailbox" withArgs:args];

        [[mailBoxDic valueForKey:key] removeObjectAtIndex:indexPath.row];
        
        dataInitCnt = [self getTotalCnt];
        
       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
