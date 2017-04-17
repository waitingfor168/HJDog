//
//  HJScreenRecorder.m
//  VideoPlayDemo
//
//  Created by whj on 2017/4/17.
//  Copyright © 2017年 dream. All rights reserved.
//

#import "HJScreenRecorder.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@interface HJScreenRecorder () <RPScreenRecorderDelegate> {

    RPScreenRecorder *_screenRecorder;
}

@end

@implementation HJScreenRecorder

+ (instancetype)sharedInstance {
    
    static HJScreenRecorder *instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[HJScreenRecorder alloc] init];
    });
    return instace;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _screenRecorder = [RPScreenRecorder sharedRecorder];
        _screenRecorder.delegate = self;
    }
    return self;
}

#pragma mark - Methods

+ (BOOL)startRecord:(BOOL)microphoneEnabled {

    return [[self sharedInstance] p_start:microphoneEnabled];
}

+ (void)stopRecord {

    [[self sharedInstance] p_stop];
}

- (BOOL)p_start:(BOOL)microphoneEnabled {
    
    if (![self isSupportedSystem]) {
        
        DEBUG_LOG(@"not support less then iOS 9.0");
        return NO;
    }
    
    if (SIMULATOR) {
        
        DEBUG_LOG(@"not support simulator");
        return NO;
    }
    
    if (!_screenRecorder.isAvailable) {
        
        DEBUG_LOG(@"not support ReplayKit");
        return NO;
    }
    
    if ([_screenRecorder isRecording]) {
        
        DEBUG_LOG(@"ScreenRecorder isRecording...");
        return NO;
    }
  
    DEBUG_LOG(@"Recorder recoderBegin");
    if ([[self delegate] respondsToSelector:@selector(recoderBegin)]) {
        [[self delegate] recoderBegin];
    }
    
    __weak typeof (self)weakSelf = self;
    [_screenRecorder startRecordingWithMicrophoneEnabled:microphoneEnabled handler:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                DEBUG_LOG(@"Recorder Fail: %@", error);
            }
            else {
                
                DEBUG_LOG(@"Recorder recoderReadyEnd");
                if ([[weakSelf delegate] respondsToSelector:@selector(recoderReadyEnd)]) {
                    [[weakSelf delegate] recoderReadyEnd];
                }
            }
        });
    }];
    
    return YES;
}

- (void)p_stop {
    
    DEBUG_LOG(@"Recorder recoderEnd");
    
    if ([[self delegate] respondsToSelector:@selector(recoderEnd)]) {
        [[self delegate] recoderEnd];
    }
    
    __weak typeof (self)weakSelf = self;
    [_screenRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                
                if ([weakSelf.delegate respondsToSelector:@selector(showSuccessViewController)]) {
                    [weakSelf.delegate showSuccessViewController];
                    
                    // 临时使用不可取
                    if ([weakSelf.delegate isKindOfClass:[UIViewController class]]) {
                        
                        id viewController = (UIViewController *)weakSelf.delegate;
                        previewViewController.previewControllerDelegate = viewController;
                        [viewController presentViewController:previewViewController animated:YES completion:^{
                            
                        }];
                    }
                }
            }
        });
    }];
}

#pragma mark - RPScreenRecorderDelegate

- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {

}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {

}

#pragma mark - Units

- (BOOL)isSupportedSystem {
    
    return [[UIDevice currentDevice].systemVersion floatValue] >= 9.0;
}

@end
