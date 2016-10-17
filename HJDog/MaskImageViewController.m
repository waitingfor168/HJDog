//
//  MaskImageViewController.m
//  HJDog
//
//  Created by whj on 16/10/17.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "MaskImageViewController.h"

@interface MaskImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MaskImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = [self maskImage:[UIImage imageNamed:@"111@2x"]];
}

- (UIImage *)maskImage:(UIImage *)image
{
        const CGFloat colorMasking[6] = {219.0, 255.0, 219.0, 255.0, 219.0, 255.0};
//    const CGFloat colorMasking[6] = {250.0, 255.0, 250.0, 255.0, 250.0, 255.0};
    CGImageRef sourceImage = image.CGImage;
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(sourceImage);
    if (info != kCGImageAlphaNone) {
        NSData *buffer = UIImageJPEGRepresentation(image, 1);
        UIImage *newImage = [UIImage imageWithData:buffer];
        sourceImage = newImage.CGImage;
    }
    
    CGImageRef masked = CGImageCreateWithMaskingColors(sourceImage, colorMasking);
    UIImage *retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}

@end
