//
//  TrashViewController.h
//  HelloMe
//
//  Created by eva.yuanzi on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMRootViewController.h"
#import "SWTableViewCell.h"

@interface TrashViewController : HMRootViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property (nonatomic)  NSMutableArray *titleArray;
@property (nonatomic)  NSMutableArray *contentArray;
@property (nonatomic)  NSMutableArray *timeArray;
@property (strong, nonatomic) IBOutlet UITableView *TrashTableView;
@end
