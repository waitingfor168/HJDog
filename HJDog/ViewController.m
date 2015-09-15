//
//  ViewController.m
//  HJDog
//
//  Created by whj on 15/7/22.
//  Copyright (c) 2015年 whj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    NSString *callback; // 定义变量用于保存返回函数
}

@property (nonatomic, weak) IBOutlet UIWebView *webViewLogin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
    [self.webViewLogin loadHTMLString:htmlString baseURL:nil];
    
//     [self.webViewLogin loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://180.76.154.254/mobile/embed/123.html"]]];
    self.webViewLogin.delegate = self;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSString *protocol = @"js-call://"; //协议名称
    
    if ([requestString hasPrefix:protocol]) {
        
        NSString *requestContent = [requestString substringFromIndex:[protocol length]];
        NSArray *vals = [requestContent componentsSeparatedByString:@"/"];
        if ([[vals objectAtIndex:0] isEqualToString:@"camera"]) { // 摄像头
            callback = [vals objectAtIndex:1];
            [self doAction:UIImagePickerControllerSourceTypeCamera];
        } else if([[vals objectAtIndex:0] isEqualToString:@"photolibrary"]) { // 图库
            callback = [vals objectAtIndex:1];
            [self doAction:UIImagePickerControllerSourceTypePhotoLibrary];
        } else if([[vals objectAtIndex:0] isEqualToString:@"album"]) { // 相册
            callback = [vals objectAtIndex:1];
            [self doAction:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        else {
            [webView stringByEvaluatingJavaScriptFromString:@"alert('未定义/lwme.cnblogs.com');"];
        }
        return NO;
    }
    return YES;
}

- (void)doAction:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imagePicker.sourceType = sourceType;
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"照片获取失败" message:@"没有可用的照片来源" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    // iPad设备做额外处理
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 3, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        // 返回图片
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 设置并显示加载动画
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"正在处理图片..." message:@"\n\n"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.center = CGPointMake(139.5, 75.5);
        [av addSubview:loading];
        [loading startAnimating];
        [av show];
        // 在后台线程处理图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // 这里可以对图片做一些处理，如调整大小等，否则图片过大显示在网页上时会造成内存警告
            NSString *base64 = [UIImageJPEGRepresentation(originalImage, 0.3) base64Encoding]; // 图片转换成base64字符串
            [self performSelectorOnMainThread:@selector(doCallback:) withObject:base64 waitUntilDone:YES]; // 把结果显示在网页上
            [av dismissWithClickedButtonIndex:0 animated:YES]; // 关闭动画
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doCallback:(NSString *)data
{
    [self.webViewLogin stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');", callback, data]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

@end
