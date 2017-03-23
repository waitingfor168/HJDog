//
//  HJScanManager.m
//  HJDog
//
//  Created by whj on 2017/3/14.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "HJScanManager.h"

@interface HJScanManager () <AVCaptureMetadataOutputObjectsDelegate> {

    __weak UIView *_preView;
}

@property (nonatomic) dispatch_queue_t captureSessionQueue;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, copy) CaptureOutput captureOutput;
@property (nonatomic, copy) CaptureOutputText captureOutputText;

@end

@implementation HJScanManager

+ (instancetype)instancePreview:(UIView *)preview {
    
    return [[self alloc] initPreview:preview];
}

- (instancetype)initPreview:(UIView *)preview {
    
    if (self = [super init]) {
        
        _preView = preview;
        
        [self initObject];
    }
    return self;
}

- (void)initObject {
    
    self.devicePosition = AVCaptureDevicePositionUnspecified;
    
    self.captureSessionQueue = dispatch_queue_create("dream.facedetector.session.queue", DISPATCH_QUEUE_SERIAL);
    self.videoDataOutputQueue = dispatch_queue_create("dream.facedetector.dataoutput.queue", DISPATCH_QUEUE_SERIAL);
    
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
//    self.captureVideoPreviewLayer.frame = _preView.frame;
//    self.captureVideoPreviewLayer.position = _preView.center;
    self.captureVideoPreviewLayer.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_preView.layer addSublayer:self.captureVideoPreviewLayer];
}

- (void)shutDown {
    
    [self.captureSession stopRunning];
    
    if (self.captureVideoPreviewLayer) {
        
        [self.captureVideoPreviewLayer removeFromSuperlayer];
        self.captureVideoPreviewLayer = nil;
    }
    
    if (self.captureMetadataOutput) {
        self.captureMetadataOutput = nil;
    }
    
    if (self.captureDeviceInput) {
        self.captureDeviceInput = nil;
    }
    
    if (self.captureDevice) {
        self.captureDevice = nil;
    }
    
    if (self.captureSession) {
        self.captureSession = nil;
    }
    
    self.captureSessionQueue = nil;
    self.videoDataOutputQueue = nil;
}

- (void)setup {
    
    [self changeCamera];
    [self setupPre];
}

- (void)sessionStart {

    [self.captureSession startRunning];
}

- (void)sessionStop {
    
    [self.captureSession stopRunning];
}

- (void)setOutput:(CaptureOutput)captureOutput {
    
    self.captureOutput = captureOutput;
}

- (void)setOutputText:(CaptureOutputText)captureOutput {

    self.captureOutputText = captureOutput;
}

- (void)cameraToggle {
    
    [self changeCamera];
    [self setupPre];
}

- (void)setupPre {
    
    dispatch_async(self.captureSessionQueue, ^{
        
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        
        self.captureDevice = [[self class] deviceType:AVMediaTypeVideo position:self.devicePosition];
        
        NSError *error = nil;
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        
        if (error) {
            NSLog(@"captureDeviceInput:%@", error);
        }
        
        [self.captureSession beginConfiguration];
        
        [self reInitSession];
        [self reInitOutput];
        
        [self resetupVideoInput];
        [self resetupVideoOutput];
        [self.captureSession commitConfiguration];
        
        if (![self.captureSession isRunning]) {
            [self.captureSession startRunning];
        }
    });
}

- (void)reInitSession {
    
    if (self.captureSession) {
        self.captureSession = nil;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    self.captureVideoPreviewLayer.session =  self.captureSession;
}

- (void)reInitOutput {
    
    if (self.captureMetadataOutput) {
        self.captureMetadataOutput = nil;
    }
    
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    self.captureConnection = [self.captureMetadataOutput connectionWithMediaType:AVMediaTypeVideo];
}

- (void)resetupVideoInput {
    
    // remove
    if (self.captureDeviceInput) {
        [self.captureSession removeInput:self.captureDeviceInput];
    }
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
}

- (void)resetupVideoOutput {
    
    // remove
    if (self.captureMetadataOutput) {
        [self.captureSession removeOutput:self.captureMetadataOutput];
    }
    
    if ([self.captureSession canAddOutput:self.captureMetadataOutput]) {
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    self.captureConnection.enabled = YES;
    if ([self.captureConnection isVideoStabilizationSupported]) {
        [self.captureConnection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
    }
    
    if ([self.captureConnection isVideoOrientationSupported]) {
        [self.captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:self.videoDataOutputQueue];
    
    //设置有效扫描区域 暂时不用置CGRectZero
    //self.captureMetadataOutput.rectOfInterest = CGRectZero;
    
    //设置扫码支持的编码格式
    self.captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                                       AVMetadataObjectTypeEAN8Code,
                                                       AVMetadataObjectTypeEAN13Code,
                                                       AVMetadataObjectTypeCode128Code];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        
        //停止扫描
//        [self.captureSession stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        //输出扫描字符串
        if (self.captureOutputText) self.captureOutputText(self, metadataObject.stringValue);
        if (self.captureOutput) self.captureOutput(captureOutput, metadataObjects, connection);
    }
}


#pragma mark - Unit

+ (AVCaptureDevice *)deviceType:(NSString *)mediaType position:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            return device;
        }
    }
    
    return nil;
}

+ (NSUInteger)cameraCount {
    
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (void)changeCamera {
    
    AVCaptureDevice *currentVideoDevice = self.captureDeviceInput.device;
    AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
    
    switch (currentPosition){
        case AVCaptureDevicePositionUnspecified:
            self.devicePosition = AVCaptureDevicePositionBack;
            break;
        case AVCaptureDevicePositionBack:
            self.devicePosition = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            self.devicePosition = AVCaptureDevicePositionBack;
            break;
    }
    
    self.isFront = currentPosition == AVCaptureDevicePositionFront;
}

@end
