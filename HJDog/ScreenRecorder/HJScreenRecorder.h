//
//  HJScreenRecorder.h
//  VideoPlayDemo
//
//  Created by whj on 2017/4/17.
//  Copyright © 2017年 dream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

/**
 系统自带录屏功能
 使用：0.引入#import "HJScreenRecorder.h"；
      1.设置代理[HJScreenRecorder sharedInstance].delegate = self，实现代理的方法;
 */

@protocol HJScreenRecoderDelegate <NSObject>

@required

- (void)showSuccessViewController;
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController;
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes;

@optional

- (void)recoderBegin;
- (void)recoderReadyEnd;
- (void)recoderEnd;

@end

@interface HJScreenRecorder : NSObject

@property(nonatomic,weak)id <HJScreenRecoderDelegate> delegate;

+ (instancetype)sharedInstance;

+ (BOOL)startRecord:(BOOL)microphoneEnabled;
+ (void)stopRecord;

@end
