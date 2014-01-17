//
//  UserInfo.h
//  HelloMeTeam1
//
//  Created by wuhh on 12/18/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPassward;

@end
