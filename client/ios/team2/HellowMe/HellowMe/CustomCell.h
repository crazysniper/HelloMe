//
//  CustomCell.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *mailid;
@property (weak, nonatomic) IBOutlet UIImageView *pngImage;

@end
