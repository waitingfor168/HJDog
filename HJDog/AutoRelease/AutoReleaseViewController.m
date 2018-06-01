//
//  AutoReleaseViewController.m
//  HJDog
//
//  Created by whj on 2018/6/1.
//  Copyright © 2018年 whj. All rights reserved.
//

#import "AutoReleaseViewController.h"

@interface AutoReleaseViewController () {
    
    // __weak 不会影响生命周期
    __weak NSString *weakString;
    __weak NSString *weakStringA;
}

@end

@implementation AutoReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /**
     reference: https://blog.csdn.net/hepburn_/article/details/47018509
     1.每个runloop中都创建一个Autorelease Pool，并在runloop的末尾进行释放;
     2.一般情况下，每个接受autorelease消息的对象，都会在下个runloop开始前被释放;
     3.NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init] 这种方法只能在MRC中使用，什么时候释放需要你自己管理。
       可以调用 [pool drain]方法进行释放。
     4.@autoreleasepool {}这种方法可以用在MRC和ARC中，它比NSAutoreleasePool更高效。这种情况在大括号结束释放。
     */
    
    weakString = [NSString stringWithFormat:@"weakString"];
    
    NSString *temString = nil;
    @autoreleasepool {
        weakStringA = [NSString stringWithFormat:@"weakStringA"];
        temString = weakStringA;
    }
    
    NSLog(@"temString: %@", temString);
    NSLog(@"weakString: %@", weakString);
    NSLog(@"weakStringA: %@", weakStringA);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear weakString: %@", weakString);
    NSLog(@"viewWillAppear weakStringA: %@", weakStringA);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear weakString: %@", weakString);
    NSLog(@"viewDidAppear weakStringA: %@", weakStringA);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 2018-06-01 15:57:07.571968+0800 HJDog[14789:1235309] temString: weakStringA
 2018-06-01 15:57:07.572152+0800 HJDog[14789:1235309] weakString: weakString
 2018-06-01 15:57:07.572236+0800 HJDog[14789:1235309] weakStringA: weakStringA
 
 2018-06-01 15:57:07.581177+0800 HJDog[14789:1235309] viewWillAppear weakString: (null)
 2018-06-01 15:57:07.581352+0800 HJDog[14789:1235309] viewWillAppear weakStringA: (null)
 
 2018-06-01 15:57:08.091785+0800 HJDog[14789:1235309] viewDidAppear weakString: (null)
 2018-06-01 15:57:08.091892+0800 HJDog[14789:1235309] viewDidAppear weakStringA: (null)
 */
@end
