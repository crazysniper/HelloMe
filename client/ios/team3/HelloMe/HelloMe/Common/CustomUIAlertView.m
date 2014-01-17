//
//  CustomUIAlertView.m
//  DIYdemo
//
//  Created by Smartphone24 on 13-9-10.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "CustomUIAlertView.h"

@implementation CustomUIAlertView
@synthesize buttonClickBlock = _buttonClickBlock;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)showWithButtonClickedBlock:(alertViewButtonClickIndex)buttonClickedBlock{
    self.delegate = self;
    self.buttonClickBlock = buttonClickedBlock;
    [self show];
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_buttonClickBlock) {
        _buttonClickBlock(buttonIndex);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
