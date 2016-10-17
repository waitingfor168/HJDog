//
//  MaskImageViewController.m
//  HJDog
//
//  Created by whj on 16/10/17.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "MaskImageViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MaskImageViewController () <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MaskImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
//    self.imageView.image = [self maskImage:[UIImage imageNamed:@"111@2x"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //在viewdidload调用下面的函数显示摄像信息
    [self setupCaptureSession];
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
//    UIImage *retImage = [UIImage imageWithCGImage:masked];
    UIImage *retImage = [UIImage imageWithCGImage:masked scale:1.0 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(masked);
    return retImage;
}

- (AVCaptureDevice *)getFrontCamera
{
    //获取前置摄像头设备
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras)
    {
        if (device.position == AVCaptureDevicePositionFront)
            return device;
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
}

- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
//    AVCaptureDevice *device = [AVCaptureDevice
//                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device = [self getFrontCamera];

    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //output.minFrameDuration = CMTimeMake(1, 15);
//    AVCaptureConnection *avcaptureconn=[[AVCaptureConnection alloc] init];
    //[avcaptureconn setVideoMinFrameDuration:CMTimeMake(1, 15)];
    // Start the session running to start the flow of data
    [session startRunning];
    AVCaptureVideoPreviewLayer* previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    previewLayer.frame = self.contentView.bounds; //视频显示到的UIView
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    [previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    //				if(previewLayer.orientationSupported){
    //					previewLayer.orientation = mOrientation;
    //				}
    
    [self.contentView.layer addSublayer: previewLayer];
    
    if(![session isRunning]){
        [session startRunning];
    }
    
    // Assign session to an ivar.
    //[self setSession:session];
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
  
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return [self maskImage:image];
}

//得到视频流
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    //得到的视频流图片
    self.imageView.image = image;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {

}

@end
