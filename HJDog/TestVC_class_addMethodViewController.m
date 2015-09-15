//
//  TestVC_class_addMethodViewController.m
//  HJDog
//
//  Created by whj on 15/9/15.
//  Copyright (c) 2015年 whj. All rights reserved.
//

#import "TestVC_class_addMethodViewController.h"
#import "MTStatusBarOverlay.h"
#import <objc/runtime.h>

@interface EmptyClass:NSObject
@end

@implementation EmptyClass
@end

@interface TestVC_class_addMethodViewController ()

@end

@implementation TestVC_class_addMethodViewController

int say(id self, SEL _cmd, NSString *str)
{
    NSLog(@"test %@", str);
    return 100;
}

void sayHello(id self, SEL _cmd)
{ NSLog(@"Hello"); }


- (void)viewDidLoad {
    [super viewDidLoad];

   //无参数
    SEL method0 = NSSelectorFromString(@"sayHello2");
    class_addMethod([EmptyClass class], method0, (IMP)sayHello, "v@:");
    EmptyClass *instance = [[EmptyClass alloc] init];
    IMP imp = [instance methodForSelector:method0];
    void (*func)(id, SEL) = (void *)imp;
    func(instance, method0);

    //有参数
    SEL method = NSSelectorFromString(@"say:");
    class_addMethod([EmptyClass class], method, (IMP)say, "i@:@");
    EmptyClass *vc = [[EmptyClass alloc] init];
    int count = (int)[vc performSelector:method withObject:@"whj"];
    NSLog(@"%d", count);
    return;
    
    [self testMTStatusBarOverlay];
}

- (void)testMTStatusBarOverlay {

    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    overlay.delegate = self;
    overlay.progress = 2.0;
    [overlay postMessage:@"Following @myell0w on Twitter…"];
    overlay.progress = 3.1;
    // ...
    [overlay postMessage:@"Following myell0w on Github…" animated:NO];
    overlay.progress = 4.5;
    // ...
    [overlay postImmediateFinishMessage:@"Following was a good idea!" duration:2.0 animated:YES];
    overlay.progress = 1.0;
    return;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
