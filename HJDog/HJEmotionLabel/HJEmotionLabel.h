//
//  HJEmotionLabel.h
//  HJDog
//
//  Created by whj on 2017/11/29.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJContextResult : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign, getter=isEmotion) BOOL isEmotion;

@end

@interface HJEmotionLabel : UILabel

@end
