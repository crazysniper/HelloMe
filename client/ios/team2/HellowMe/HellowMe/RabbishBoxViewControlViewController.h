//
//  RabbishBoxViewControlViewController.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-16.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RabbishBoxViewControlViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myRabbishTableView;
@property (weak, nonatomic) IBOutlet UILabel *loginUserName;

@end
