//
//  TrashViewController.m
//  HelloMe 垃圾箱
//
//  Created by eva.yuanzi on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "TrashViewController.h"
#import "ImageFactory.h"
#import "ColorUtil.h"
#import "EvaTrashCell.h"
#import "DetailEmailViewController.h"
#import "EmailLogic.h"
#import "ThemeManager.h"
@interface TrashViewController (){
    NSInteger index;
    NSMutableArray *cellArray;
    MailDTO *sendMail;
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
	// Do any additional setup after loading the view.
    [self regitserAsObserver];
    [self configureViews];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName, nil]];
    
    
    cellArray = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    cellArray = [EmailLogic getMailInfoBoxIDLAJI];
    [self.TrashTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EvaTrashIdentifier = @"EvaTrashIdentifier";
    
    EvaTrashCell *cell = (EvaTrashCell *)[tableView dequeueReusableCellWithIdentifier:EvaTrashIdentifier];
    if (cell == nil) {
        cell = [[EvaTrashCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:EvaTrashIdentifier];
    }
    MailDTO *dto = (MailDTO *)cellArray[indexPath.row];
    
    cell.TrashTitle.text  = dto.subject;
    cell.TrashTitle.highlighted = YES;
    cell.TrashTime.text = dto.sendTime;
    cell.TrashContent.text = dto.text;
    [cell setCellHeight:cell.frame.size.height];
    cell.TrashContent.numberOfLines = 2;
    cell.containingTableView = tableView;
    cell.delegate = self;
    return cell;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [cellArray count];

}
// 给detail画面传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailSegue"]){
        DetailEmailViewController *gotoDetail = (DetailEmailViewController*)segue.destinationViewController  ;
        gotoDetail.mailDto = sendMail;
        gotoDetail.mailList = cellArray;
        gotoDetail.index = index;
    }
}
    
// 单击cell进入detail画面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sendMail = [cellArray objectAtIndex:(indexPath.row)];
    index= [indexPath row];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];

}



@end
