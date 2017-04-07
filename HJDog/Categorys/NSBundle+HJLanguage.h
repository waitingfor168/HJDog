//
//  NSBundle+HJLanguage.h
//  HJDog
//
//  Created by whj on 2017/4/6.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HJLStringsName  @"hjdog"
#define HJLLocalizedString(key, comment) \
[NSBundle hj_localizedStringForKey:(key) value:@"" table:HJLStringsName]
#define HJLLocalizedStringFromTable(key, tbl, comment) \
[NSBundle hj_localizedStringForKey:(key) value:@"" table:(tbl)]

FOUNDATION_EXTERN NSString *const NOTIFICATION_HJLANGUAGE_CHANGE_KEY;

@interface NSBundle (HJLanguage)

+ (NSBundle *)HJInstance;
+ (NSString *)userCurrentLanguage;
+ (void)setUserCurrentlanguage:(NSString *)language;
+ (NSArray *)userCurrentlanguages;
+ (NSString *)hj_localizedStringForKey:(NSString *)key;
+ (NSString *)hj_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

+ (void)hj_addNotification:(NSObject *)target selector:(SEL)aSelector;
+ (void)hj_removeNotification:(NSObject *)target;

@end
