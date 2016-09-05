//
//  MainViewController.m
//  HJDog
//
//  Created by whj on 16/7/21.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)loadView {
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
    
}
- (void)loadViewIfNeeded {
    [super loadViewIfNeeded];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
}

- (void)viewWillUnload {
    [super viewWillUnload];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
}    // Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
}   // Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
}// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
} // Called after the view was dismissed, covered or otherwise hidden. Default does nothing

// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewWillLayoutSubviews NS_AVAILABLE_IOS(5_0) {
    [super viewWillLayoutSubviews];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
}
// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewDidLayoutSubviews NS_AVAILABLE_IOS(5_0) {
    [super viewDidLayoutSubviews];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog((@"%s "), __PRETTY_FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
