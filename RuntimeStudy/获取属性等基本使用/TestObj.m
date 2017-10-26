//
//  TestObj.m
//  RuntimeStudy
//
//  Created by chenwang on 2017/10/24.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "TestObj.h"

#import <objc/runtime.h>

@implementation TestObj

/**
 获取property
 */
- (void)getPropertyNames {
    unsigned int count;
    objc_property_t *prelist = class_copyPropertyList([self class], &count);
    [self forMethodWithCount:count methodBlock:^(int index) {
        objc_property_t pre = prelist[index];
        const char *preName = property_getName(pre);
        NSString *preNameString = [NSString stringWithCString:preName encoding:NSUTF8StringEncoding];
        NSLog(@"propertyName --> %@", preNameString);
    }];
    free(prelist);
}


/**
 获取所有的成员变量
 */
- (void)getIvarNames {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    [self forMethodWithCount:count methodBlock:^(int index) {
        Ivar ivar = ivarList[index];
        const char *name = ivar_getName(ivar);
        NSString *nameString = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"ivarName --> %@", nameString);
    }];
    free(ivarList);
}


/**
 获取所有的方法
 */
- (void)getMethodNames {
    unsigned int count;
    Method *methodList = class_copyMethodList([self class], &count);
    [self forMethodWithCount:count methodBlock:^(int index) {
        Method method = methodList[index];
        SEL sel = method_getName(method);
        NSLog(@"methodName --> %@", NSStringFromSelector(sel));
    }];
    free(methodList);
}

/**
 获取遵循的所有协议
 */
- (void)getProtocolNames {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    [self forMethodWithCount:count methodBlock:^(int index) {
        Protocol *protocol = protocolList[index];
        const char *name = protocol_getName(protocol);
        NSString *nameString = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"protocolName --> %@", nameString);
    }];
    free(protocolList);
}

- (void)forMethodWithCount:(unsigned int)count methodBlock:(void (^)(int index))methodBlock {
    for(int i = 0; i < count; i++) {
        if(methodBlock) {
            methodBlock(i);
        }
        
        if(i == count - 1) {
            NSLog(@"\n");
        }
    }
}
@end
