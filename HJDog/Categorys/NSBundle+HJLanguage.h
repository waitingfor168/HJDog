//
//  NSBundle+HJLanguage.h
//  HJDog
//
//  Created by whj on 2017/4/6.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *NOTIFICATION_HJLANGUAGE_CHANGE;

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
