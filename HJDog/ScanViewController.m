//
//  ScanViewController.m
//  HJDog
//
//  Created by whj on 2017/3/15.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "ScanViewController.h"
#import "HJScanManager.h"
#import "HJImagePickerController.h"
#import "GenerateViewController.h"
#import "UIImage+HJDetector.h"

@interface ScanViewController () {

    HJScanManager *scanManage;
}
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Scan";
    
    __weak typeof(self) weakSelf = self;
    scanManage = [HJScanManager instancePreview:self.view];
    [scanManage setup];
    [scanManage setOutputText:^(HJScanManager *manager, NSString *message) {
        
        NSLog(@"===>>:%@", message);
        [manager sessionStop];
        [weakSelf p_showAlert:message];
    }];
    
    [self.view bringSubviewToFront:self.baseView];
}

- (void)dealloc {

    [scanManage shutDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"%s", __func__);
}

#pragma mark - Action

- (IBAction)openPhotoAction:(id)sender {
    
    WS
    [[HJImagePickerController hjImagePickerController:self] openPhoto:^(UIImage *image, NSDictionary *info) {
        SWS
        NSString *message = [image hjQrDetector] ?: @"不存在，请重新选择。";
        [strongSelf p_showAlert:message];
    }];
}

- (IBAction)generateAction:(id)sender {
    
    GenerateViewController *viewController = [[GenerateViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Units

- (void)p_showAlert:(NSString *)message {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"code" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [scanManage sessionStart];
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

@end
