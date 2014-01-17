//
//  HMRootViewController.h
//  HelloMe
//
//  Created by 陳威 on 13-12-15.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RevealBlock)();

@interface HMRootViewController : UIViewController{
@private
	RevealBlock _revealBlock;
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock withIdentity:(NSString *)IdentityId;

@end
