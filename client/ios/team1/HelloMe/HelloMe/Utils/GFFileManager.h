//
//  GFFileManager.h
//  HelloMe
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFFileManager : NSObject {
    NSFileManager *fileManager;
    NSString *baseDirPath;
    
}
@property(nonatomic,retain) NSFileManager *fileManager;
@property(nonatomic,retain) NSString *baseDirPath;

//-(id)initAnimationImage;
-(id)initWithFolder:(NSString *)folderName;
-(BOOL)isLocalFileExists:(NSString*)fileName;
-(BOOL)createDirectoryWithCheck:(NSString*)dirPath;
-(BOOL)saveLocalFile:(NSString*)localImagePath :(NSData*)imageData;
//-(NSString *)captureImageName:(NSString *)imageUrl;
-(NSString*)getLocalFilePath:(NSString*)fileName;
-(void)deleteLocalFilePath;
-(void)setBaseFilePath:(NSString *)folderName;

@end
