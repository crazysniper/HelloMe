//
//  LoginViewController.h
//  HellowMe
//
//  Created by 銭 宇傑 on 2013/12/17.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<NSXMLParserDelegate,  NSURLConnectionDelegate>


@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@property BOOL loginResult;
@property BOOL recordResults;


@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;


- (IBAction)login:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)regist:(id)sender;
- (IBAction)view_touchDown:(id)sender;


@end
