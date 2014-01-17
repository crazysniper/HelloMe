//
//  SettingCell.h
//  HelloMe
//
//  Created by 陳威 on 13-12-17.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *setNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextImage;
@property (weak, nonatomic) IBOutlet UISwitch *receiveSwitch;

@end
