//
//  FingerPrintViewController.m
//  HJDog
//
//  Created by whj on 16/9/29.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "FingerPrintViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingerPrintViewController ()

@end

@implementation FingerPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self p_testFingerPrint];
}

- (void)p_testFingerPrint {

    //初始化
    LAContext *context = [LAContext new];
    
    /** 这个属性用来设置指纹错误后的弹出框的按钮文字
     *  不设置默认文字为“输入密码”
     *  设置@""将不会显示指纹错误后的弹出框
     */
    context.localizedFallbackTitle = @"忘记密码";
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"指纹验证"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success) {
                                  //验证成功执行
                                  NSLog(@"指纹识别成功");
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@"在主线程刷新view，不然会有卡顿");
                                  });
                              } else {
                                  
                                  if (error.code == kLAErrorUserFallback) {
                                      //Fallback按钮被点击执行
                                      NSLog(@"Fallback按钮被点击");
                                  } else if (error.code == kLAErrorUserCancel) {
                                      //取消按钮被点击执行
                                      NSLog(@"取消按钮被点击");
                                  } else {
                                      //指纹识别失败执行
                                      NSLog(@"指纹识别失败");
                                  }
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@"在主线程刷新view，不然会有卡顿");
                                  });
                              }
                          }];
        
    } else {
    
        NSLog(@"设备不支持，%@", error);
    }
    
}

@end
