//
//  HassendCell.h
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface HassendCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *emaiTitle;
@property (weak, nonatomic) IBOutlet UILabel *emailTime;
@property (weak, nonatomic) IBOutlet UILabel *emailDetail;
@property (weak, nonatomic) IBOutlet UIImageView *emailNextImage;

@end
