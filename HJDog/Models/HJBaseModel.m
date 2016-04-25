//
//  HJBaseModel.m
//  HJDream
//
//  Created by whj on 16/4/22.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "HJBaseModel.h"

@implementation HJBaseModel

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)objectForDictionary:(NSDictionary *)dictioary {
    
    id model = [self sharedInstance];
    
    unsigned int index = 0;
    Ivar *ivars = class_copyIvarList([self class], &index);
    
    for (int i = 0 ; i < index; i++) {
        
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        
        id value = nil;
        NSString *key = [NSString stringWithUTF8String:name];
        
        if ([key hasPrefix:@"_"]) {
            value = [dictioary valueForKey:[key substringFromIndex:1]];
        }
        
        if (value == nil) continue;
        [model setValue:value forKey:key];
    }
    free(ivars);
    
    return model;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    //定义长度
    unsigned int index = 0;
    
    //动态获取类成员变量数组
    Ivar *ivars = class_copyIvarList([self class], &index);
    
    for (int i = 0; i < index; i++) {
        
        //取出对应的变量
        Ivar ivar = ivars[i];
        
        //获取取出的变量名
        const char *name = ivar_getName(ivar);
        
        //归档:归档调用方法encodeObject: forKey:
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    //释放获取的变量数组
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        unsigned int index = 0;

        Ivar *ivars = class_copyIvarList([self class], &index);
        for (int i = 0 ; i < index; i++) {

            Ivar ivar = ivars[i];

            NSString *key = @(ivar_getName(ivar));
            id value = [aDecoder decodeObjectForKey:key];

            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    id baseModel = [[[self class] allocWithZone:zone] init];
    
    unsigned int index = 0;
    Ivar *ivars = class_copyIvarList([self class], &index);
    
    for (int i = 0 ; i < index; i++) {
        
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        
        NSString *nameGet = nil;
        NSString *nameSet = nil;
        NSString *key = [NSString stringWithUTF8String:name];
        
        // accountName
        if ([key hasPrefix:@"_"]) {
            nameGet = [key substringFromIndex:1];
        }
        
        // setAccountName:
        NSString *capitalizedString = [[nameGet substringToIndex:1] uppercaseString];
        NSMutableString *tempMutableString = [[NSMutableString alloc] initWithString:nameGet];
        [tempMutableString replaceCharactersInRange:NSMakeRange(0, 1) withString:capitalizedString];
        nameSet = [NSString stringWithFormat:@"set%@:", tempMutableString];
        
        ((void (*)(id, SEL, NSString *))(void *)objc_msgSend)((id)baseModel, sel_registerName([nameSet UTF8String]), (NSString *)((id (*)(id, SEL, NSZone * _Nullable))(void *)objc_msgSend)((id)((NSString *(*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName([nameGet UTF8String])), sel_registerName("copyWithZone:"), (NSZone * _Nullable)zone));
    }
    free(ivars);
    
    return baseModel;
}

#pragma mark - OverWrite

- (NSString *)description {
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (int index = 0; index < count; index++) {
        
        const char *name = ivar_getName(ivars[index]);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        
        dictionary[key] = value;
    }
    free(ivars);
    
    return dictionary.description;
}

@end
