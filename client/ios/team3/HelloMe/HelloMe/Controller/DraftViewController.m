//
//  DraftViewController.m
//  HelloMe 草稿箱
//
//  Created by 姚明壮 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "DraftViewController.h"
#import "ColorUtil.h"
#import "ImageFactory.h"
#import "HMDraftCell.h"
#import "EmailLogic.h"
#import "EditViewController.h"
#import "ThemeManager.h"

@interface DraftViewController (){
    NSMutableArray *cellArray;
    NSInteger index;
    MailDTO *sendMail;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

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
	// Do any additional setup after loading the view.
    [self regitserAsObserver];
    [self configureViews];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
        NSForegroundColorAttributeName, nil]];
    
    cellArray = [[NSMutableArray alloc]init];
    NSLog(@"AAA viewDidLoad");
}
- (void)viewWillAppear:(BOOL)animated{
    
    cellArray = [EmailLogic getMailInfoBoxIDCAOGAO];
    [self.tableView reloadData];
    NSLog(@"AAA  viewWillAppear");
}    // Called when the view is about to made visible. Default does nothing

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
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *TableSampleIdentifier = @"DraftIdentifier";
    
    HMDraftCell *cell = (HMDraftCell*)[tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[HMDraftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableSampleIdentifier];
    }
    MailDTO *dto = (MailDTO *)cellArray[indexPath.row];

    cell.title.text = dto.subject;
    cell.title.highlighted=YES;
    
    cell.content.text = dto.text;
    cell.timeLable.numberOfLines=2;
    cell.timeLable.text = dto.sendTime;
    [cell setCellHeight:cell.frame.size.height];
    cell.containingTableView = tableView;
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    NSLog(@"%@",cell.content.text);
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellArray count];
}

// 给edit画面传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"drafttoEdit"]){
        EditViewController *gotoEdit = (EditViewController *)segue.destinationViewController  ;
        gotoEdit.drafttoEdit = @"drafttoEdit";
        gotoEdit.mailDto = sendMail;
        gotoEdit.mailList = cellArray;
        gotoEdit.index = index;
    }
}
// 单击cell跳转edit画面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sendMail = [cellArray objectAtIndex:(indexPath.row)];
    index = [indexPath row];
    [self performSegueWithIdentifier:@"drafttoEdit" sender:self];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
   // [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor redColor]
//                                                 icon:[UIImage imageNamed:@"main_setting.png"]];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor greenColor]
//                                                 icon:[UIImage imageNamed:@"main_inbox.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor brownColor]
                                                 icon:[UIImage imageNamed:@"main_trash.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:(HMDraftCell *)cell];
            
            [EmailLogic delateCAOGAO:(MailDTO *)cellArray[cellIndexPath.row]];
            //[self.tableView reloadData];
            [cellArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            NSLog(@"删除");
            break;        }
        default:
            break;
    }
}
@end
