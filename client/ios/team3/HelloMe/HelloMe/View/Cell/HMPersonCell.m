//
//  HMPersonCell.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMPersonCell.h"
#import "ColorUtil.h"
@implementation HMPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
		
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor clearColor];
        [bgView setAlpha:0.0f];
		self.selectedBackgroundView = bgView;
		self.imageView.contentMode = UIViewContentModeCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.4f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [ColorUtil colorFromColorString:@"C4CCDA"];
        self.textLabel.textAlignment=NSTextAlignmentCenter;
		
	}
	return self;
}
#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(23.0f, 60.0f, 200.0f, 43.0f);
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
	self.imageView.frame = CGRectMake(90.0f, 8.0f, 60.0f, 60.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
