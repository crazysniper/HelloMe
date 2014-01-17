//
//  TrashViewController.h
//  HelloMeTeam1 回收箱
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface TrashViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSString *division;
}

@property (weak, nonatomic) IBOutlet UILabel *trash_Number;
@property (weak,nonatomic) Message *messageTrash;
@property (nonatomic, retain) NSMutableArray *messageArrayforTrash;
@property (weak, nonatomic) IBOutlet UILabel *trashCount;

@end
