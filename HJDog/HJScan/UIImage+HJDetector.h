//
//  UIImage+HJDetector.h
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJDetector)

/**
 识别二维码

 @return 识别结果
 */
- (NSString *)hjQrDetector;

@end
