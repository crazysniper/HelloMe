//
//  CustomPicker.h
//  DIYdemo
//
//  Created by Smartphone24 on 13-9-2.
//  Copyright (c) 2013年 ldns. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^okButtonPressed_t)(id retValue);

@interface CustomPicker : NSObject

//PickerView
+ (void)showPickWithDelegate:(id)delegate
               selectedValue:(id)value
                contentPlist:(NSDictionary *)dic
             okButtonPressed:(okButtonPressed_t)buttonBlock;

+ (void)showPickWithDelegate:(id)delegate
               selectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray
             okButtonPressed:(okButtonPressed_t)buttonBlock;

+ (void)showPickWithDelegate:(id)delegate
              componentWidth:(CGFloat)width
               selectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray
             okButtonPressed:(okButtonPressed_t)buttonBlock;

//DatePicker
+ (void)showDatePickWithDelegate:(id)delegate selectedDate:(NSDate *)date okButtonPressed:(okButtonPressed_t)buttonBlock;

+ (void)showMinSecDatePickWithDelegate:(id)delegate selectedDate:(NSInteger)sec okButtonPressed:(okButtonPressed_t)buttonBlock;

@end

