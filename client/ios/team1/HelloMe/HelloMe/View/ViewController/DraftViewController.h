//
//  DraftViewController.h
//  HelloMeTeam1 草稿箱
//
//  Created by 高丰 on 2013/12/16.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface DraftViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *draft_Number;
@property (nonatomic, retain) NSMutableArray *messageArrayforDraft;
@property (weak,nonatomic) Message *messageDraft;
@property (strong,nonatomic) NSString *flg;
@property (strong, nonatomic) UITableView *draftTableView;
@property (weak, nonatomic) IBOutlet UILabel *draftCount;
@end
