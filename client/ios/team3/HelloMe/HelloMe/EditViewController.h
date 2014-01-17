//
//  EditViewController.h
//  HelloMe
//
//  Created by Eva.yuanzi on 2013/12/16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "ViewController.h"

@interface EditViewController : ViewController
- (IBAction)sendmail:(id)sender;
- (IBAction)selecttime:(id)sender;
@property (strong, nonatomic) IBOutlet UITabBarItem *delete;
@property (strong, nonatomic) IBOutlet UITabBarItem *Favorites;

@end
