//
//  ImagePickerManager.h
//  imagePicker
//
//  Created by eva.yuanzi on 13-12-20.
//  Copyright (c) 2013年 MTI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^selectedImage_t)(UIImage *image);

@interface ImagePickerManager : NSObject

+ (void)showImagePickerOnTarget:(id)target imageSelected:(selectedImage_t)selectedImageBlock;

@end
