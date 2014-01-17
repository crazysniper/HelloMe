//
//  RegistViewController.h
//  HellowMe
//
//  Created by 銭 宇傑 on 2013/12/18.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController<NSXMLParserDelegate,  NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;

- (IBAction)submit:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)back:(id)sender;

- (IBAction)view_touchDown:(id)sender;

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@property BOOL registResult;
@property BOOL recordResults;

@end
