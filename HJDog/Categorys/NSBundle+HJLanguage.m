//
//  NSBundle+HJLanguage.m
//  HJDog
//
//  Created by whj on 2017/4/6.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "NSBundle+HJLanguage.h"

#define HJLNotificationCenter [NSNotificationCenter defaultCenter]
#define HJLUserDefaults [NSUserDefaults standardUserDefaults]

static NSBundle *HJLBundle = nil;
NSString *const NOTIFICATION_HJLANGUAGE_CHANGE_KEY = @"notification.hjlanguage.change.key";

@implementation NSBundle (HJLanguage)

#pragma mark - Methods

+ (NSBundle *)HJInstance {

    NSString *language = [self userCurrentLanguage];
    
    if (language.length == 0) {
        
        NSArray* languages = [self userCurrentlanguages];
        language = [languages firstObject];
        
        [[self class] setUserCurrentlanguage:language];
    }
    
    return HJLBundle;
}

+ (NSString *)userCurrentLanguage {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [userDefaults valueForKey:@"userLanguage"];
    
    return language;
}

+ (void)setUserCurrentlanguage:(NSString *)language {
    
    language = [language stringByReplacingOccurrencesOfString:@"-CN" withString:@""];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    HJLBundle = [NSBundle bundleWithPath:path];
    
    [HJLUserDefaults setValue:language forKey:@"userLanguage"];
    [HJLUserDefaults synchronize];
    
    [HJLNotificationCenter postNotificationName:NOTIFICATION_HJLANGUAGE_CHANGE_KEY object:nil];
}

+ (NSArray *)userCurrentlanguages {

    return [HJLUserDefaults objectForKey:@"AppleLanguages"];
}

+ (NSString *)hj_localizedStringForKey:(NSString *)key {
    
    return [self hj_localizedStringForKey:key value:nil table:HJLStringsName];;
}

+ (NSString *)hj_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {

    return [HJLBundle localizedStringForKey:key value:value table:tableName];
}

#pragma mark - NotificationCenter

+ (void)hj_addNotification:(NSObject *)target selector:(SEL)aSelector {
    
    [HJLNotificationCenter addObserver:target selector:aSelector name:NOTIFICATION_HJLANGUAGE_CHANGE_KEY object:nil];
}

+ (void)hj_removeNotification:(NSObject *)target {

    [HJLNotificationCenter removeObserver:target name:NOTIFICATION_HJLANGUAGE_CHANGE_KEY object:nil];
}

@end
