//
//  GenerateViewController.m
//  HJDog
//
//  Created by whj on 2017/3/23.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "GenerateViewController.h"
#import "NSString+HJGenerateImage.h"

@interface GenerateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barImageView;

@end

@implementation GenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.textField resignFirstResponder];
}

- (IBAction)generateCodeImage:(id)sender {

    NSString *string = self.textField.text;
    
    if (!string) {
        return;
    }
    
    UIImage *imageBar = [string generateBarSize:CGSizeMake(240, 128)];
    [self.barImageView setImage:imageBar];
    
    UIImage *imageQr = [string generateQrSize:CGSizeMake(240, 240)];
    [self.qrImageView setImage:imageQr];
    
    [self.textField resignFirstResponder];
}

@end
