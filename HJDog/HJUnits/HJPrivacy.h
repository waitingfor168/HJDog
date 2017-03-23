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

@interface HJPrivacy : NSObject

/**
 *  获取全局唯一的一个对象
 *
 *  @return 对象
 */
+ (instancetype)defaultInstance;

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
