//
//  HJImagePickerController.h
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJImagePickerControllerDelegate;

typedef void(^HJBlock)(UIImage *image, NSDictionary *info);
typedef HJBlock HJPhotoBlock;
typedef HJBlock HJCameraBlock;

@interface HJImagePickerController : UIImagePickerController

+ (instancetype)hjImagePickerController:(id)target;

- (void)openPhoto:(HJPhotoBlock)block;
- (void)openCamera:(HJCameraBlock)block;

@property (nonatomic, weak) id <HJImagePickerControllerDelegate> hjDelegate;

@end

@protocol HJImagePickerControllerDelegate <NSObject>
@optional

- (void)hjImagePickerController:(HJImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image;
- (void)hjImagePickerController:(HJImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
