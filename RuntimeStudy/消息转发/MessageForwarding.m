//
//  MessageForwarding.m
//  RuntimeStudy
//
//  Created by chenwang on 2017/10/26.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "MessageForwarding.h"

#import <objc/runtime.h>

@implementation MessageForwarding

- (void)messageForwardingTest {
    
    /*
     对象执行一个方法流程
     第一步：检测这个selector是不是要被忽略的。
     第二步：检测这个target对象是不是nil对象。（nil对象执行任何一个方法都不会Crash，因为会被忽略掉）
     第三步：首先会根据target对象的isa指针获取它所对应的类（class）。
     第四步：优先在类（class）的cache里面查找与选择子（selector）名称相符，如果找不到，再到methodLists查找。
     第五步：如果没有在类（class）找到，再到父类（super_class）查找，再到元类（metaclass），直至根metaclass。
     第六步：一旦找到与选择子（selector）名称相符的方法，就跳至其实现代码。如果没有找到，就会执行消息转发（message forwarding）。
    */
    MessageForwarding *mf = [[MessageForwarding alloc] init];
    mf.testString = @"test";
    if([(NSString *)mf isEqualToString:@"test"]) {
        NSLog(@"相等!!!");
    }
    /*因为MessageForwarding 是没有实现 isEqualToString这个方法的,所以这里执行此方法.这里虽然强转了下类型,编译能通过,运行的时候是会抛出异常的*/
}

/*
 所以我们可以利用消息转发机制来做一些处理
 消息转发步骤
 第一步：对象在收到无法解读的消息后，首先调用resolveInstanceMethod：方法决定是否动态添加方法。如果返回YES，则调用class_addMethod动态添加方法，消息得到处理，结束；如果返回NO，则进入下一步；
 第二步：当前接收者还有第二次机会处理未知的选择子，在这一步中，运行期系统会问：能不能把这条消息转给其他接收者来处理。会进入forwardingTargetForSelector:方法，用于指定备选对象响应这个selector，不能指定为self。如果返回某个对象则会调用对象的方法，结束。如果返回nil，则进入下一步；
 第三步：这步我们要通过methodSignatureForSelector:方法签名，如果返回nil，则消息无法处理。如果返回methodSignature，则进入下一步；
 第四步：这步调用forwardInvocation：方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等，如果方法调用成功，则结束。如果失败，则进入doesNotRecognizeSelector方法，抛出异常，此异常表示选择子最终未能得到处理
 */

BOOL myIsEqualToString(id self, SEL _cmd, NSString *senderString) {
    return [((MessageForwarding *)self).testString isEqualToString:senderString];
}

//在第一步中做处理,返回YES,并动态添加自定义的处理方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    return NO;
    /*
     默认是return NO;
     return YES的话需要自己做一些处理,这里我们动态给该类添加方法
     */
//    if(sel == NSSelectorFromString(@"isEqualToString:")) {
//        class_addMethod([self class], sel, (IMP)myIsEqualToString, "i@:@");
//        //第四个参数不懂的跳转:https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
//    }
//    return YES;
}

//在第二步处理,返回能够响应该selectro的对象
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    /*默认是返回nil*/
    return nil;
    
//    if(aSelector == NSSelectorFromString(@"isEqualToString:")) {
//        return self.testString;
//    }
//    return nil;
}

//第三.四步: 通过methodSignatureForSelector:方法签名，如果返回nil，则消息无法处理。如果返回methodSignature，则进入下一步；
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if(aSelector == NSSelectorFromString(@"isEqualToString:")) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"i@:@"];
        return signature;
    }
    return nil;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    //第四步：这步调用forwardInvocation：方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等，如果方法调用成功，则结束。如果失败，则进入doesNotRecognizeSelector方法，抛出异常，此异常表示选择子最终未能得到处理
    if(anInvocation.selector == NSSelectorFromString(@"isEqualToString:")) {
        anInvocation.target = self.testString;
        [anInvocation invoke];
    }
}
@end
