//
//  HJPerson.m
//  HJDog
//
//  Created by whj on 2018/5/31.
//  Copyright © 2018年 whj. All rights reserved.
//

#import "HJPerson.h"
#import <objc/runtime.h>

@implementation HJPerson

+ (void)classMethodPrint {
    
    NSLog(@"classMethodPrint");
}

- (void)objectMethodPrint {
    
    NSLog(@"objectMethodPrint\n");
    
    NSLog(@"self Object: %@.", self);
    NSLog(@"self Class: %@:%p.", [self class], [self class]);
    NSLog(@"self Super: %@:%p.\n", [self superclass], [self superclass]);
    
    NSLog(@"NSObject's class is %p.", [NSObject class]);
    NSLog(@"NSObject's meta class is %p.", object_getClass([NSObject class]));
    
    const char *name = object_getClassName(self);
    Class metaClass = objc_getMetaClass(name);
    NSLog(@"MetaClass: %@:%p.\n",metaClass, metaClass);
    
    int index = 0;
    Class tmpClass = [self class];
    Class currentClass = [self class];
    do {
        NSLog(@"\nFollowing the isa pointer %d times gives %p", index, currentClass);
        unsigned int countMethod = 0;
        NSLog(@"---------------**%d start %@**-----------------------",index, currentClass);
        Method * methods = class_copyMethodList(currentClass, &countMethod);
        [self print:countMethod methods:methods ];
        NSLog(@"---------------**%d end**-----------------------\n",index);
        
        index ++;
        tmpClass = currentClass;
        currentClass = object_getClass(currentClass);
        NSLog(@"%@: %p", tmpClass, tmpClass);
        NSLog(@"%@: %p", currentClass, currentClass);
        
    } while (tmpClass != currentClass);
    
//    int index = 0;
//    Class superClass = [self class];
//    Class currentClass = [self class];
//    do {
//        NSLog(@"\nFollowing the isa pointer %d times gives %p", index, currentClass);
//        unsigned int countMethod = 0;
//        NSLog(@"---------------**%d start %@**-----------------------",index, currentClass);
//        Method * methods = class_copyMethodList(currentClass, &countMethod);
//        [self print:countMethod methods:methods ];
//        NSLog(@"---------------**%d end**-----------------------\n",index);
//
//        index ++;
//        if (index % 2 == 0 ) superClass = [superClass superclass]; // object_getClass经过两个（获取类和获取元类）
//
//        NSLog(@"%@: %p", currentClass, currentClass);
//        currentClass = object_getClass(currentClass);
//        NSLog(@"%@: %p", currentClass, currentClass);
//
//    } while (superClass != nil);
}

- (void)print:(int)count methods:(Method *)methods{
    
    for (int j = 0; j < count; j++) {
        
        Method method = methods[j];
        SEL methodSEL = method_getName(method);
        const char * selName = sel_getName(methodSEL);
        if (methodSEL) {
            NSLog(@"SEL: %s", selName);
        }
    }
}

@end
