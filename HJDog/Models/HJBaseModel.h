//
//  HJBaseModel.h
//  HJDream
//
//  Created by whj on 16/4/22.
//  Copyright © 2016年 whj. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface HJBaseModel : NSObject <NSCoding, NSCopying>

/**
 *  获取全局的实例
 *
 *  @return 返回实例
 */
+ (instancetype)sharedInstance;

/**
 *  给实例对象赋值
 *
 *  @param dictioary 数据源
 *
 *  @return 带数据的实例
 */
+ (instancetype)objectForDictionary:(NSDictionary *)dictioary;

@end
