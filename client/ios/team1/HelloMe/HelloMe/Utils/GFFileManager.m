//
//  GFFileManager.m
//  HelloMe
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import "GFFileManager.h"
#import "Define.h"

@implementation GFFileManager

@synthesize baseDirPath;
@synthesize fileManager;

//初期化だけ
-(id)init{

    self = [super init];
    if(self){
        fileManager = [[NSFileManager alloc] init];
    }
    return self;

}

// ローカルフォルダ管理の初期化
-(void)setBaseFilePath:(NSString *)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, folderName];
    
    if (![self createDirectoryWithCheck:dirPath]) {
        NSLog(@"create dir error.");
    }
    
    self.baseDirPath = dirPath;
    
}

////ローカル動画画像の初期化
//-(id)initAnimationImage {
//    self = [super init];
//    if(self){
//        fileManager = [[NSFileManager alloc] init];
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *flag = (NSString *)[defaults valueForKey:IMAGE_FILE_KEY];
//        
//        if ([@"1" isEqualToString:flag])
//        {
//            NSString *dirPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,LOCAL_RESULT_IMAGE_PATH];
//            if (![self createDirectoryWithCheck:dirPath]) {
//                
//                NSLog(@"create dir err");
//            }
//            
//            self.baseDirPath = dirPath;
//        }
//        else
//        {
//            NSString *dirPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,LOCAL_HOME_IMAGE_PATH];
//            if (![self createDirectoryWithCheck:dirPath]) {
//                
//                NSLog(@"create dir err");
//            }
//            
//            self.baseDirPath = dirPath;
//        }
//    }
//    return self;
//}

// ローカルフォルダ管理の初期化
-(id)initWithFolder:(NSString *)folderName
{
    self = [super init];
    if(self){
        fileManager = [[NSFileManager alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *dirPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, folderName];
        
        if (![self createDirectoryWithCheck:dirPath]) {
            NSLog(@"create dir error.");
        }
        
        self.baseDirPath = dirPath;
    }
    return self;
}


//指定したローカルファイルの存在チェック
-(BOOL)isLocalFileExists:(NSString*)fileName{
    NSString *localfilePath;
    localfilePath = [NSString stringWithFormat:@"%@/%@", baseDirPath, fileName];

    return [fileManager fileExistsAtPath:localfilePath];
}

//ディレクトリ関連

//ディレクトリの存在チェックをした後ディレクトリ作成
-(BOOL)createDirectoryWithCheck:(NSString*)dirPath{
    BOOL retFlg = YES;
    
    if(![fileManager fileExistsAtPath:dirPath]){
        retFlg = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return retFlg;
}

//// キャプチャーイメージの名前
//- (NSString *)captureImageName:(NSString *)imageUrl
//{
//    if (imageUrl == nil)
//    {
//        return  imageUrl;
//    }
//    else
//    {
//        NSMutableArray *contactsTmpArray = [[NSMutableArray alloc] initWithArray:[imageUrl  componentsSeparatedByString:CONST_MAILTO_SPLIT]];
//    
//        NSString *retStr = [contactsTmpArray objectAtIndex:[contactsTmpArray count] - 1];
//    
//        [contactsTmpArray release];
//        
//        return retStr;
//    }
//    
//}

// ファイル操作

// ローカルファイル保存処理
-(BOOL)saveLocalFile:(NSString*)localImagePath :(NSData*)imageData{
    return [fileManager createFileAtPath:localImagePath contents:imageData attributes:nil];
}

// ファイルパス文字列取得関連

// ローカルファイルパスの取得処理
-(NSString*)getLocalFilePath:(NSString*)fileName{
    NSString *retStr;
    retStr = [NSString stringWithFormat:@"%@/%@", baseDirPath, fileName];

    return retStr;
}

// ローカルファイルパスの削除
-(void)deleteLocalFilePath{
    [[NSFileManager defaultManager] removeItemAtPath:baseDirPath error:nil];
}

@end
