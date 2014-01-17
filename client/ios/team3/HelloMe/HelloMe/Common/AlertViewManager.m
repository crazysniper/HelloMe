//
//  AlertViewManager.m
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "AlertViewManager.h"

@interface CustomAlertView : UIAlertView<UIAlertViewDelegate> {
@private
    alertViewButtonClick_t _buttonClickedBlock;
}

@property (nonatomic, strong) alertViewButtonClick_t buttonClickedBlock;

-(void) showWithButtonClickedBlock:(alertViewButtonClick_t)buttonClickedBlock;

@end

@implementation CustomAlertView
@synthesize buttonClickedBlock = _buttonClickedBlock;

-(void) showWithButtonClickedBlock:(alertViewButtonClick_t)buttonClickedBlock {
    self.delegate = self;
    self.buttonClickedBlock = buttonClickedBlock;
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_buttonClickedBlock) {
        _buttonClickedBlock(buttonIndex);
    }
}

@end

@implementation AlertViewManager

+ (CustomAlertView *)showAlertWithMessage:(NSString *)message {
    return [AlertViewManager showAlertWithTitle:nil message:message buttons:[NSArray arrayWithObject:@"OK"] onButtonClicked:nil];
}

+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    return [AlertViewManager showAlertWithTitle:title message:message buttons:[NSArray arrayWithObject:@"OK"] onButtonClicked:nil];
}

+ (CustomAlertView *)showAlertWithMessage:(NSString *)message onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock {
    return [AlertViewManager showAlertWithTitle:nil message:message buttons:[NSArray arrayWithObject:@"OK"] onButtonClicked:buttonClickedBlock];
}

+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock {
    return [AlertViewManager showAlertWithTitle:title message:message buttons:[NSArray arrayWithObject:@"OK"] onButtonClicked:buttonClickedBlock];
}

+ (CustomAlertView *)showAlertWithMessage:(NSString *)message buttons:(NSArray *)buttons onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock {
    return [AlertViewManager showAlertWithTitle:nil message:message buttons:buttons onButtonClicked:buttonClickedBlock];
}

+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock {
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    alertView.title = title;
    alertView.message = message;
    if (buttons) {
        for (NSString *buttonTitle in buttons) {
            [alertView addButtonWithTitle:buttonTitle];
        }
    }
    [alertView showWithButtonClickedBlock:buttonClickedBlock];
    return alertView;
}

+ (void)dismissCustomAlertView:(CustomAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:-1 animated:NO];
}
@end
