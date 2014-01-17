//
//  CommonDao.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	SORT_TYPE_ASCEND = 1,
	SORT_TYPE_DECEND = 0
} SORT_TYPE;

typedef enum {
	RESULT_OK = 1,
	RESULT_NG = 0
} RESULT_TYPE;

static NSString * const FUNC_MIX = @"max:";
static NSString * const FUNC_MIN = @"min:";
static NSString * const FUNC_SUM = @"sum:";

@interface CommonDao : NSObject {
    NSManagedObjectContext *context;
}

- (id)initWithContext:(NSManagedObjectContext *)paramContext;


- (NSManagedObject *)createEntity:(Class)entityClass;

//条件取得
- (BOOL)getEntities:(NSArray **)entities withEntityClass:(Class)entityClass;
- (BOOL)getEntities:(NSArray **)entities withEntityClass:(Class)entityClass orderBy:(NSString *)orderBy asc:(SORT_TYPE)asc;

//
- (BOOL)getEntities:(NSArray **)entities  withEntityClass:(Class)entityClass byConditions:(NSDictionary *)conditions;
//条件取得 with Predicate
- (BOOL)getEntities:(NSArray **)entities withEntityClass:(Class)entityClass byConditionWithPredicate:(NSPredicate *)conditionsWithPredicate;
//条件取得order
- (BOOL)getEntities:(NSArray **)entities withEntityClass:(Class)entityClass byConditions:(NSDictionary *)conditions orderBy:(NSString *)orderBy asc:(SORT_TYPE)asc;
//条件取得order with Predicate
- (BOOL)getEntities:(NSArray **)entities withEntityClass:(Class)entityClass byConditionWithPredicate:(NSPredicate *)conditionsWithPredicate orderBy:(NSString *)orderBy asc:(SORT_TYPE)asc;

//fetching Specific Values
- (BOOL)getSpecificValues:(NSArray **)dicArray withEntityClass:(Class)entityClass byExpressionDescription:(NSExpressionDescription *)expressionDescription;
- (BOOL)getSpecificValues:(NSArray **)dicArray withEntityClass:(Class)entityClass byExpressionDescription:(NSExpressionDescription *)expressionDescription byConditions:(NSDictionary *)conditions;
- (BOOL)getSpecificValues:(NSArray **)dicArray withEntityClass:(Class)entityClass byExpressionDescription:(NSExpressionDescription *)expressionDescription byConditionWithPredicate:(NSPredicate *)conditionsWithPredicate;

//delate
- (BOOL)removeAllEntity:(Class)entityClass;
//delate with
- (BOOL)removeEntity:(Class)entityClass byConditions:(NSDictionary *)conditions;
- (BOOL)removeEntity:(Class)entityClass byConditionWithPredicate:(NSPredicate *)conditionWithPredicate;
//delate
- (void)removeEntity:(NSManagedObject **)entity;

//commit
- (BOOL)saveAction;
//Rollback
- (void)rollbackAction;

- (void)mergeChanges:(NSNotification *)notification;

- (NSExpressionDescription *)createExpressionDescription:(NSString *)predefinedFunc column:(NSString *)column descriptionName:(NSString *)name;
@end
