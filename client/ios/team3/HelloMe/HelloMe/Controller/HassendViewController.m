//
//  HassendViewController.m
//  HelloMe 已发送
//
//  Created by 陳威 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HassendViewController.h"
#import "ColorUtil.h"
#import "ImageFactory.h"
#import "SWTableViewCell.h"
#import "HassendCell.h"
#import "EmailLogic.h"
#import "MailDTO.h"
#import "ThemeManager.h"
@interface HassendViewController (){
    NSMutableArray *emailArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HassendViewController

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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName, nil]];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    emailArray = [[NSMutableArray alloc] init];
    emailArray = [EmailLogic getMailInfoByUserName];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return [self.filteredNoteArray count];
//    }
    return [emailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HassendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HassendCell" forIndexPath:indexPath];
    [cell setCellHeight:cell.frame.size.height];
    cell.containingTableView = tableView;
    
    MailDTO *dto = emailArray[indexPath.row];
    
    cell.emaiTitle.text = dto.subject;
    cell.emailTime.text = [NSString stringWithFormat:@"%@—%@",dto.sendTime,dto.receiveTime];
    cell.emailDetail.text = dto.text;
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor redColor]
                                                 icon:[UIImage imageNamed:@"cell_file.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor greenColor]
                                                 icon:[UIImage imageNamed:@"cell_colleate.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor brownColor]
                                                 icon:[UIImage imageNamed:@"cell_delate.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"文件夹");
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"收藏");
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 2:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:(HassendCell *)cell];
            
           
            [emailArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
         
           
            
            
            NSLog(@"删除");
            break;
        }
        default:
            break;
    }
}
@end
