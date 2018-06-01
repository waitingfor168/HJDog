//
//  HJPerson.h
//  HJDog
//
//  Created by whj on 2018/5/31.
//  Copyright © 2018年 whj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJPerson : NSObject

+ (void)classMethodPrint;

- (void)objectMethodPrint;

@end

/**
 reference: http://www.cocoachina.com/ios/20180110/21805.html
 
 isa.png图
 1.每个实例对象的类都是类对象，每个类对象的类都是元类对象，每个元类对象的类都是根元类（root meta class的isa指向自身）；
 2.类对象的父类最终继承自根类对象NSObject，NSObject的父类为nil；
 3.元类对象（包括根元类）的父类最终继承自根类对象NSObject；
 4.类与元类是一个闭环；
 
 
 @interface NSObject <NSObject> {
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wobjc-interface-ivars"
 Class isa  OBJC_ISA_AVAILABILITY;
 #pragma clang diagnostic pop
 }
 
 /// An opaque type that represents an Objective-C class.
 typedef struct objc_class *Class;
 
 /// Represents an instance of a class.
 struct objc_object {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 };
 
 
 #ifdef __OBJC__
 @class Protocol;
 #else
 typedef struct objc_object Protocol;
 #endif
 
 
 struct objc_class {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class _Nullable super_class                              OBJC2_UNAVAILABLE;
 const char * _Nonnull name                               OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
 struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
 struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
 #endif
 
 } OBJC2_UNAVAILABLE;
  Use `Class` instead of `struct objc_class *`
 
 */
