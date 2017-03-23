//
//  UIImage+HJDetector.m
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "UIImage+HJDetector.h"

@implementation UIImage (HJDetector)

- (NSString *)hjQrDetector {

    NSDictionary *options = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
    
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
    NSArray *features = [detector featuresInImage:ciImage];
    
    if (features.count > 0) {
        
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        
        return scannedResult;
    }
    
    return nil;
}

@end
