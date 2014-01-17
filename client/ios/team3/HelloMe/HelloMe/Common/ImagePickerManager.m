//
//  ImagePickerManager.m
//  imagePicker
//
//  Created by 陳威 on 13-12-20.
//  Copyright (c) 2013年 MTI. All rights reserved.
//

#import "ImagePickerManager.h"


@interface ImagePickerView : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    selectedImage_t _selectedImageBlock;
}

@property (nonatomic ,strong) UIImagePickerController *imagePickerController;

- (void)showImagePickerWithTarget:(id)target imageSelected:(selectedImage_t)selectedImageBlock;

@end

@implementation ImagePickerView


- (void)showImagePickerWithTarget:(id)target imageSelected:(selectedImage_t)selectedImageBlock {
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [target presentModalViewController:_imagePickerController animated:YES];
    
    _selectedImageBlock = selectedImageBlock;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *cameraImage;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        
        cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_selectedImageBlock) {
        _selectedImageBlock(cameraImage);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

static ImagePickerView *imagePickerView = nil;

@implementation ImagePickerManager

+ (void)showImagePickerOnTarget:(id)target imageSelected:(selectedImage_t)selectedImageBlock {
    imagePickerView = [[ImagePickerView alloc]init];
    [imagePickerView showImagePickerWithTarget:target imageSelected:selectedImageBlock];
}

@end
