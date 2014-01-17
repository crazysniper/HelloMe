//
//  RabbishCell.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-17.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RabbishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *mailid;
@property (weak, nonatomic) IBOutlet UIImageView *pngImage;

@end
