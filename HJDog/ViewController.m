//
//  ViewController.m
//  HJDog
//
//  Created by whj on 15/7/22.
//  Copyright (c) 2015年 whj. All rights reserved.
//

#import "ViewController.h"

#import "HJAccountInfo.h"
#import "UndoViewController.h"
#import "ScanViewController.h"
#import "MainViewController.h"
#import "LanguageViewController.h"
#import "MaskImageViewController.h"
#import "FingerPrintViewController.h"
#import "TransformImageViewController.h"
#import "AutoReleaseViewController.h"
#import "HJURLProtocol.h"
#import "HJPerson.h"

@interface ViewController () <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    NSString *callback; // 定义变量用于保存返回函数
}

@property (nonatomic, weak) IBOutlet UIWebView *webViewLogin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NSURLProtocol registerClass:[HJURLProtocol class]];
//    [self p_testInfo];
//    [self p_testWebView];
//    [self p_isa];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(p_trst) withObject:nil afterDelay:2.0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [NSURLProtocol unregisterClass:[HJURLProtocol class]];
}

- (void)p_isa {
    
    [[[HJPerson alloc] init] objectMethodPrint];
}

- (void)p_testInfo {

    NSDictionary *dictionary = @{@"accountId" : @"15988889595"
                                 , @"accountName" : @"Dream"
                                 , @"accountCode" : @"200"
                                 , @"accountMark" : @"1"};
    HJAccountInfo *accountInfo = [HJAccountInfo objectForDictionary:dictionary];
    NSLog(@"accountInfo:%@", accountInfo);

    // NSUserDefaults 只支持基本的数据类型存储, 所以使用NSKeyedArchiver序列化
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accountInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"accountInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSData *dataResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountInfo"];
    HJAccountInfo *accountInfoResult = [NSKeyedUnarchiver unarchiveObjectWithData:dataResult];
    NSLog(@"accountInfoResult:%@", accountInfoResult);
    
    HJAccountInfo *accountInfoCopy = [accountInfoResult copy];
    NSLog(@"accountInfoResult:%@", accountInfoCopy);
}

- (void)p_testWebView {

//    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"html"];
//    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
//    [self.webViewLogin loadHTMLString:htmlString baseURL:nil];
    
    //     [self.webViewLogin loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://180.76.154.254/mobile/embed/123.html"]]];
    [self.webViewLogin loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://www.baidu.com"]]];
    self.webViewLogin.delegate = self;
}

- (IBAction)rightAction:(id)sender {
    
    ScanViewController *viewController = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)leftAction:(id)sender {
    
    LanguageViewController *viewController = [[LanguageViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)p_trst {

//    MainViewController *mainViewController = [[MainViewController alloc] init];
//     WeakTast(mainViewController)
//    [self presentViewController:mainViewController animated:YES completion:^{
//        StrongTast(weak_mainViewController)
//        NSLog(@"==>>:%@", strong_weak_mainViewController);
//    }];
    
    AutoReleaseViewController *viewController = [[AutoReleaseViewController alloc] init];
//    UndoViewController *viewController = [[UndoViewController alloc] init];
//    FingerPrintViewController *viewController = [[FingerPrintViewController alloc] init];
//    MaskImageViewController *viewController = [[MaskImageViewController alloc] init];
//    TransformImageViewController *viewController = [[TransformImageViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


}

@end
