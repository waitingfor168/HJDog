//
//  HJPrivacy.h
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HJALAuthorization)(BOOL status);
typedef void(^HJAVAuthorization)(BOOL status);

#define hjinterface_sio(name) \
@interface name : NSObject \
+ (instancetype)sharedInstance;

#define hjimplementation_sio(name) \
@implementation name \
+ (instancetype)sharedInstance { \
    static name *instance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [[name alloc] init]; \
    }); \
    return instance; \
}

hjinterface_sio(HJPrivacy)

/**
 *  检测相册权限
 *
 *  @param block 回掉
 */
- (void)accessLibrary:(HJALAuthorization)block;

/**
 *  检测相机权限
 *
 *  @param block 回掉
 */
- (void)accessCamera:(HJAVAuthorization)block;

@end
