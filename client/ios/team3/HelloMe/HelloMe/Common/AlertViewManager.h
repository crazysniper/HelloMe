//
//  AlertViewManager.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^alertViewButtonClick_t)(int buttonIndex);

@class CustomAlertView;
@interface AlertViewManager : NSObject

+ (CustomAlertView *)showAlertWithMessage:(NSString *)message;
+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (CustomAlertView *)showAlertWithMessage:(NSString *)message onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock;
+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock;
+ (CustomAlertView *)showAlertWithMessage:(NSString *)message buttons:(NSArray *)buttons onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock;
+ (CustomAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons onButtonClicked:(alertViewButtonClick_t)buttonClickedBlock;

+ (void)dismissCustomAlertView:(CustomAlertView *)alertView;

@end
