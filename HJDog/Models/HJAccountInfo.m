//
//  HJAccountInfo.m
//  HJDog
//
//  Created by whj on 16/4/21.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "HJAccountInfo.h"

#import <objc/runtime.h>

@implementation HJAccountInfo

+ (HJAccountInfo *)sharedInstance {

    static HJAccountInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HJAccountInfo alloc] init];
    });
    return instance;
}

+ (HJAccountInfo *)objectForDictionary:(NSDictionary *)dictioary {

    HJAccountInfo *accountInfo = [HJAccountInfo sharedInstance];
    
    accountInfo.accountId           = dictioary[@"accountId"];
    accountInfo.accountName         = dictioary[@"accountName"];
    accountInfo.accountCode         = dictioary[@"accountCode"];
    accountInfo.accountMark         = dictioary[@"accountMark"];
    
    return accountInfo;
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
/*
    [aCoder encodeObject:self.accountId forKey:@"accountId"];
    [aCoder encodeObject:self.accountName forKey:@"accountName"];
    [aCoder encodeObject:self.accountCode forKey:@"accountCode"];
    [aCoder encodeObject:self.accountMark forKey:@"accountMark"];
 */
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
        
        //定义长度
        unsigned int index = 0;
        //动态获取成员变量数组
        Ivar *ivars = class_copyIvarList([self class], &index);
        for (int i = 0 ; i < index; i++) {
            //取出变量
            Ivar ivar = ivars[i];
            //获取变量名
            const char *name = ivar_getName(ivar);
            //解档:解档调用方法decodeObjectForKey
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            //赋值
            [self setValue:value forKey:key];
        }
        //由于这里是使用的C语言，需要自己手动管理内存
        free(ivars);
        /*
        self.accountId = [aDecoder decodeObjectForKey:@"accountId"];
        self.accountName = [aDecoder decodeObjectForKey:@"accountName"];
        self.accountCode = [aDecoder decodeObjectForKey:@"accountCode"];
        self.accountMark = [aDecoder decodeObjectForKey:@"accountMark"];
        */
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    HJAccountInfo *accountInfo = [[[self class] allocWithZone:zone] init];
    
    accountInfo.accountId = [self.accountId copyWithZone:zone];
    accountInfo.accountName = [self.accountName copyWithZone:zone];
    accountInfo.accountCode = [self.accountCode copyWithZone:zone];
    accountInfo.accountMark = [self.accountMark copyWithZone:zone];
    
    return accountInfo;
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
