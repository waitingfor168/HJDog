//
//  HJImagePickerController.m
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "HJImagePickerController.h"
#import "HJPrivacy.h"

@interface HJImagePickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    __weak UIViewController<HJImagePickerControllerDelegate> *_target;
}

@property (nonatomic, copy) HJPhotoBlock photoBlock;
@property (nonatomic, copy) HJCameraBlock cameraBlock;

@end

@implementation HJImagePickerController

+ (instancetype)hjImagePickerController:(id)target {
    
    return [[HJImagePickerController alloc] initWithTarget:target];
}

- (id)initWithTarget:(id)target {
    
    if (self = [super init]) {
        
        [self setDelegate:self];
        [self setAllowsEditing:YES];
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        _target = target;
        [self setHjDelegate:_target];
    }
    
    return self;
}

- (void)openCamera:(HJCameraBlock)block {
    
    if (block) {
        self.cameraBlock = block;
    }
    
    [[HJPrivacy sharedInstance] accessCamera:^(BOOL authorized) {
        
        if (authorized) {
            
            if ([HJImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                [self setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self setShowsCameraControls:YES];
                
                [HJRootViewController presentViewController:self animated:YES completion:nil];
            }else{
                
                DEBUG_LOG(@"No Camera");
            }
        }
    }];
}

- (void)openPhoto:(HJPhotoBlock)block {
    
    if (block) {
        self.photoBlock = block;
    }
    
    [[HJPrivacy sharedInstance] accessLibrary:^(BOOL authorized) {
        
        if (authorized) {
            
            [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [HJRootViewController presentViewController:self animated:YES completion:nil];
        }
    }];
}

#pragma mark - UINavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    navigationController.navigationBar.titleTextAttributes = dict;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    navigationController.navigationBar.titleTextAttributes = dict;
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info == nil) {
        
        DLog(@"PickingMediaInfo not can not nil");
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:^{
            
            if (self.photoBlock) {
                self.photoBlock(image, info);
            }
            
            if (self.cameraBlock) {
                self.cameraBlock(image, info);
            }
            
            if (self.hjDelegate) {
                
                if ([self.hjDelegate respondsToSelector:@selector(hjImagePickerController:didFinishPickingMediaWithImage:)]) {
                    [self.hjDelegate hjImagePickerController:self didFinishPickingMediaWithImage:image];
                }
                
                if ([self.hjDelegate respondsToSelector:@selector(hjImagePickerController:didFinishPickingMediaWithInfo:)]) {
                    [self.hjDelegate hjImagePickerController:self didFinishPickingMediaWithInfo:info];
                }
            }
        }];
    }
}

@end
