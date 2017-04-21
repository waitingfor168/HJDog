//
//  HJSingleton.h
//  HJDog
//
//  Created by whj on 2017/4/21.
//  Copyright © 2017年 whj. All rights reserved.
//

#ifndef HJSingleton_h
#define HJSingleton_h

// .h文件 shared##name 是让前面HJSingletonH(name) 接收到的参数拼接起来
#define HJSingletonH(name) + (instancetype)shared##name;

// .m文件

// ARC
#if __has_feature(objc_arc)

#define HJSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [super allocWithZone:zone]; \
    }); \
    return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [[self alloc] init]; \
    }); \
    return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instace; \
}

// 非ARC
#else

#define HJSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [super allocWithZone:zone]; \
    }); \
    return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [[self alloc] init]; \
    }); \
    return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instace; \
} \
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif

#endif /* HJSingleton_h */
