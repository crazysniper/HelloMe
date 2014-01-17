//
//  HMDraftCell.h
//  HelloMe
//
//  Created by Smartphone21 on 12/17/13.
//  Copyright (c) 2013 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface HMDraftCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@end
