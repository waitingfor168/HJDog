//
//  HJHeader.h
//  chargingtimefm
//
//  Created by whj on 2016/12/28.
//  Copyright © 2016年 yinmeng. All rights reserved.
//

#ifndef HJHeader_h
#define HJHeader_h

// DEBUG_LOG
#ifdef DEBUG
# define DEBUG_LOG(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define DEBUG_LOG(fmt, ...)
# define DLog(fmt, ...)
#endif

//UIApplication
#define FMApplication          [UIApplication sharedApplication]
#define FMKeyWindow            FMApplication.keyWindow
#define FMKeyWindowBounds      FMKeyWindow.bounds

#define PATH_OF_DOCUMENT  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//system
#define IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define IOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

#define AppScale  MAX([[UIScreen mainScreen] scale],2) //设备分辨率  最小2x图

#define AppInfoDictionary  [[NSBundle mainBundle] infoDictionary]  //app应用数据
#define AppName            [AppInfoDictionary objectForKey:@"CFBundleDisplayName"]
#define AppVersion         [AppInfoDictionary objectForKey:@"CFBundleShortVersionString"]
#define AppShareDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGBCA(c, a) RGBA(c,c,c,a)
#define RGBC(c) RGBCA(c, 1.0f)

#define ColorTopBar RGB(43, 46, 51)
#define Color8 RGB(136, 136, 136)
#define ColorWordGreyc RGBC(204)
#define ColorWordGrey9 RGBC(153)
#define ColorWordGrey6 RGBC(102)
#define ColorWordGrey3 RGBC(51)

#define HJScreenBound [UIScreen mainScreen].bounds
#define HJKeyWindow [UIApplication sharedApplication].keyWindow
#define HJRootViewController [HJKeyWindow rootViewController]
#define HJStringUnion(header, tail) [NSString stringWithFormat:@"%@%@", header, tail]
#define HJObjectLazyInit(object, value) if(object==nil){object=value;}

/** 弱引用 */
#define WS __weak typeof(self) weakSelf = self;
#define WeakObj(obj) __weak typeof(obj) weakObj = obj;

/** 强引用 */
#define SWS __weak typeof(weakSelf) strongSelf = weakSelf;
#define StrongObj(obj) __strong typeof(obj) strongObj = obj;

#endif /* HJHeader_h */
