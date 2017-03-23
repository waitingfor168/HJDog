//
//  HJScanManager.h
//  HJDog
//
//  Created by whj on 2017/3/14.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class HJScanManager;

typedef void(^CaptureOutput)(AVCaptureOutput *captureOutput, NSArray* metadataObjects, AVCaptureConnection *connection);
typedef void(^CaptureOutputText)(HJScanManager *manager, NSString *message);

@interface HJScanManager : NSObject

+ (instancetype)instancePreview:(UIView *)preview;

- (void)setOutput:(CaptureOutput)captureOutput;
- (void)setOutputText:(CaptureOutputText)captureOutput;

- (void)setup;
- (void)shutDown;

- (void)sessionStart;
- (void)sessionStop;

/**
 * 切换摄像头
 */
- (void)cameraToggle;

/**
 * 是否为前置摄像头
 */
@property (nonatomic, assign) BOOL isFront;

@end
