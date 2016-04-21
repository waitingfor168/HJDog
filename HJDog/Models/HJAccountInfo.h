//
//  HJAccountInfo.h
//  HJDog
//
//  Created by whj on 16/4/21.
//  Copyright © 2016年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJAccountInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountCode;
@property (nonatomic, strong) NSString *accountMark;

+ (HJAccountInfo *)sharedInstance;
+ (HJAccountInfo *)objectForDictionary:(NSDictionary *)dictioary;

@end
