//
//  ViewController.m
//  RuntimeStudy
//
//  Created by chenwang on 2017/10/24.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "ViewController.h"

#import "TestObj.h"
#import "MessageForwarding.h"

typedef void (^NormalBlock)(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //invocation使用示例
//    self.invocation();
    
    //消息转发示例
    MessageForwarding *mf = [[MessageForwarding alloc] init];
    [mf messageForwardingTest];
}

- (void)classLogTest {
    [[[TestObj alloc] init] getPropertyNames];
    
    [[[TestObj alloc] init] getIvarNames];
    
    [[[TestObj alloc] init] getMethodNames];
    
    [[[TestObj alloc] init] getProtocolNames];
}

- (void)invocationTest {
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(classLogTest)];
    if(signature == nil) {
        //此方法不存在,抛出异常
        NSString *reason = [NSString stringWithFormat:@"%@ 不能响应此方法 %@", NSStringFromClass([self class]), NSStringFromSelector(@selector(classLogTest))];
        @throw [NSException exceptionWithName:@"error" reason:reason userInfo:@{}];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    invocation.selector = @selector(classLogTest);
    
    ///算出参数的个数, 默认有一个_cmd 一个target 所以要-2
    NSInteger count = signature.numberOfArguments - 2;
    if(count > 0) {
        /*
         for(int index = 0; index < count; index ++) {
             [invocation setArgument:@"参数" atIndex:index + 2];
         }
         设置参数时,按顺序来,下标需要加2
         */
    }
    [invocation invoke];
    
    if(signature.methodReturnLength) {
        //不为空说明此方法有返回值
        id returnValue = nil;
        [invocation getReturnValue:&returnValue];
    }
}

- (NormalBlock)invocation {
    return ^(){
        [self invocationTest];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
