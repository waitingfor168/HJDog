//
//  LanguageViewController.m
//  HJDog
//
//  Created by whj on 2017/4/6.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "LanguageViewController.h"
#import "NSBundle+HJLanguage.h"

@interface LanguageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initView];
    
    // 初始化
    [NSBundle HJInstance];
    
    // 注册通知，用于接收改变语言的通知
    [NSBundle hj_addNotification:self selector:@selector(changeLanguage)];
    
}

- (void)dealloc {

    [NSBundle hj_removeNotification:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)p_initView {

    NSArray *languages = [NSBundle userCurrentlanguages];
    
    for (NSString *language in languages) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:language forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10, 100, 80, 35)];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:button];
    }
}

#pragma mark - Action

- (void)changeLanguage {

    NSString *title = [NSBundle hj_localizedStringForKey:@"title"];
    
    [self.titleLabel setText:title];
}


@end
