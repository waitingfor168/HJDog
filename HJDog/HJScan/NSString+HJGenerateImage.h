//
//  NSString+HJGenerateImage.h
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HJGenerateImage)

- (UIImage *)generateQrSize:(CGSize)size;
- (UIImage *)generateBarSize:(CGSize)size;

- (UIImage *)generateQrSize:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;
- (UIImage *)generateBarSize:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;

@end
