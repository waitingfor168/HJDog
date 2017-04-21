//
//  HJPrivacy.m
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "HJPrivacy.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

hjimplementation_sio(HJPrivacy)

- (void)accessLibrary:(HJALAuthorization)block {
    
    if (IOS8) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            
            [self p_accessLibraryAlert:block];
            
        } else if (status == PHAuthorizationStatusNotDetermined) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (status == PHAuthorizationStatusAuthorized && block) block(YES);
                    });
                }];
            });
            
        } else {
            
            if (block) block(YES);
        }
        
    } else {
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            
            [self p_accessLibraryAlert:block];
            
        } else {
            
            if (block) block(YES);
        }
    }
}

- (void)accessCamera:(HJAVAuthorization)block
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        if (block) block(YES);
        return;
    }
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:NSLocalizedString(@"STR_CAMERA_VISIT_PROWER", "camera visit prower")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertAction];
        [HJRootViewController presentViewController:alertController animated:YES completion:nil];
    }
    else {
        
        if (block) block(YES);
    }
}

- (void)p_accessLibraryAlert:(HJALAuthorization)block {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"STR_PHOTOS_VISIT_PROWER", @"warning open photo prower")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                        }];
    [alertController addAction:alertAction];
    [HJRootViewController presentViewController:alertController animated:YES completion:nil];
}

@end

