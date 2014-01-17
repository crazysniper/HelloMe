//
//  AppDelegate.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *kUserName;
    NSString *kPassword;
}

@property (strong, nonatomic) NSString *kUserName;
@property (strong, nonatomic) NSString *kPassword;

@property (strong, nonatomic) UIWindow *window;

@end
