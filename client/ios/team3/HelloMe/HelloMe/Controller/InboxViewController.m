//
//  InboxViewController.m
//  HelloMe  收件箱
//
//  Created by 王赛 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "InboxViewController.h"
#import "ColorUtil.h"
#import "ImageFactory.h"
#import "InboxMailCells.h"
#import "DetailEmailViewController.h"
#import "SWTableViewCell.h"
#import "User.h"
#import "MailDTO.h"
#import "EmailLogic.h"
#import "ThemeManager.h"
#import "KeychainAccessor.h"
#import "NSDateExtras.h"
#import "MBProgressHUD.h"
@interface InboxViewController()
{
   
    NSMutableArray *_mailList;
    NSInteger _index;
    MailDTO *_sendMail;
    
}

@end

@implementation InboxViewController

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
    [self regitserAsObserver];
    [self configureViews];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                  NSForegroundColorAttributeName, nil]];
   
    
     _mailList = [[NSMutableArray alloc] init];
     _mailList = [EmailLogic getMailInfoBoxIDSHOUJIAN];
    NSLog(@"%@",_mailList);
    
    //获取新邮件（以下七句）
	NSString *userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSString *currentTime = [[NSDate now] stringFormat:@"yyyyMMddHHmm"];
    GetNewMailsNetwork*network=[[GetNewMailsNetwork alloc] init];
    network.delegate = self;
    MailDTO*dto=[[MailDTO alloc] init];
    dto.userName=userName;
    dto.sendTime=currentTime;
    [network getNewMails:dto];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.inboxTableView.bounds.size.height, self.view.frame.size.width, self.inboxTableView.bounds.size.height)];
		view.delegate = self;
		[self.inboxTableView addSubview:view];
		_refreshHeaderView = view;
				
	}
}
//没有新邮件的处理
- (void)getNewMailsFailed
{
    if (_reloading) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        //    HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"kuface.png"] TransformtoSize:CGSizeMake(40, 40)]] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"您没有新邮件";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}
//有新邮件的处理
- (void)getNewMailsSuccessd
{
    NSLog(@"www*******************");
    _mailList = [[NSMutableArray alloc] init];
    _mailList = [EmailLogic getMailInfoBoxIDSHOUJIAN];
    [self.inboxTableView reloadData];
    NSLog(@"eeeeeee%d",_mailList.count);
}

- (void)regitserAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(configureViews)
                   name:ThemeDidChangeNotification
                 object:nil];
}
- (void)configureViews
{
    
    if (IOS_VERSION >= 7.0f) {
        self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedInstance]colorWithColorName];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[ImageFactory imageRectangleWithColor:[[ThemeManager sharedInstance]colorWithColorName] size:self.navigationController.navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InboxMailCells *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxMailCells" forIndexPath:indexPath];
    
    // 给cell赋值
    MailDTO *mailDto = [_mailList objectAtIndex:(indexPath.row)];
    [cell setCellHeight:cell.frame.size.height];
    cell.containingTableView = self.inboxTableView;
    
    cell.inboxMailTitle.text = mailDto.subject;
    cell.inboxMailTime.text = mailDto.receiveTime;
    cell.inboxMailText.text = mailDto.text;
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mailList.count;
}
// 跳转到后详细画面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inboxMail"]){
        DetailEmailViewController *detailMail = (DetailEmailViewController*)segue.destinationViewController  ;
        detailMail.mailDto = _sendMail;
        detailMail.mailList = _mailList;
        detailMail.index = _index;
    }
}

// 给后画面传值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _sendMail = [_mailList objectAtIndex:(indexPath.row)];
    _index = [indexPath row];
    [self performSegueWithIdentifier:@"inboxMail" sender:self];
    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor redColor]
//                                                 icon:[UIImage imageNamed:@"cell_file.png"]];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor greenColor]
//                                                 icon:[UIImage imageNamed:@"cell_colleate.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor brownColor]
                                                 icon:[UIImage imageNamed:@"cell_delate.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.inboxTableView indexPathForCell:(InboxMailCells *)cell];
            [EmailLogic deleteSHOUJIAN:(MailDTO *)_mailList[cellIndexPath.row]];
            MailDTO *dto = [[MailDTO alloc]init];
            dto = (MailDTO *)_mailList[cellIndexPath.row];
            dto.boxId = 3;
            [EmailLogic addMailInfoTOLoaclDB:dto];
            [_mailList removeObjectAtIndex:cellIndexPath.row];
            [self.inboxTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            NSLog(@"删除");
            break;
        }
        default:
            break;
    }
}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    //获取新邮件（以下七句）
	NSString *userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSString *currentTime = [[NSDate now] stringFormat:@"yyyyMMddHHmm"];
    GetNewMailsNetwork*network=[[GetNewMailsNetwork alloc] init];
    network.delegate = self;
    MailDTO*dto=[[MailDTO alloc] init];
    dto.userName=userName;
    dto.sendTime=currentTime;
    [network getNewMails:dto];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用   
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading;
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date];
}
@end
