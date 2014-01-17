//
//  InboxViewController.h
//  HelloMe
//
//  Created by 陳威 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "HMRootViewController.h"
#import "SWTableViewCell.h"
#import "GetNewMailsNetwork.h"
#import "EGORefreshTableHeaderView.h"
@interface InboxViewController : HMRootViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,GetNewMailsDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    
}
@property(nonatomic,retain)UIImageView *barView;
@property (weak, nonatomic) IBOutlet UITableView *inboxTableView;

@end
