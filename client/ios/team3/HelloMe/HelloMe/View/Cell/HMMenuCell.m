//
//  HMMenuCell.m
//  HelloMe
//
//  Created by 陳威 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMMenuCell.h"
#import "ColorUtil.h"

NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";


@implementation HMMenuCell

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
        
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [ColorUtil colorFromColorString:@"C4CCDA"];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [ColorUtil colorFromColorString:@"363D47"];
		[self.textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [ColorUtil colorFromColorString:@"363D47"];
		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [ColorUtil colorFromColorString:@"282F3D"];
		[self.textLabel.superview addSubview:bottomLine];
	}
	return self;
}
#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(40.0f, 0.0f, 200.0f, 43.0f);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
	self.imageView.frame = CGRectMake(6.0f, 8.0f, 25.0f, 25.0f);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
