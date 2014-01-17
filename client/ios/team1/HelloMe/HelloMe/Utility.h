
#import <UIKit/UIKit.h>

/*!
	@class		Utility
	@abstract	ユーティリティ
 */
@interface Utility : NSObject {

}

#pragma mark -

/*!
	@method
	@abstract char型ポインタのデータが文字列のデータに変更する
	@param    message char型ポインタのデータ
	@result   文字列のデータ
 */
+ (NSString *)CharToNSString:(char *)message;

/*!
	@method
	@abstract	NSDate形日付をNSString形日付に転化する
	@param		date NSDate形日付
	@result		NSString形日付"yyyy/mm/dd"
 */
+ (NSString *)NSDateToNSString:(NSDate *)date;

/*!
	@method
	@abstract 数値データが文字列のデータに変更する。
	@param    day 数値データ
	@result   文字列のデータ
 */
+ (NSString *)NSIntegerToNSStringText:(NSInteger)day;

/*!
	@method
	@abstract 文字列の非空チェック処理
	@param    message 文字列
	@result   チェック結果
 */
+ (BOOL)checkNSString:(NSString *)message;



/*!
 @method
 @abstract get current version
 @result   int current version
 */
+ (NSString *)getCurrentVersion;

/*!
 @method
 @abstract get current version database name
 @result   int current version database name
 */
+ (NSString *)getCurrentVersionDBName;

@end
