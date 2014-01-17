//
//  EvaTrashCell.h
//  HelloMe
//
//  Created by eva.yuanzi on 2013/12/18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface EvaTrashCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TrashTitle;
@property (strong, nonatomic) IBOutlet UILabel *TrashTime;

@property (strong, nonatomic) IBOutlet UILabel *TrashContent;
@end
