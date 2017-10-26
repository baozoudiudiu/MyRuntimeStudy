//
//  TestObj.h
//  RuntimeStudy
//
//  Created by chenwang on 2017/10/24.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 /// 描述类中的一个方法
 typedef struct objc_method *Method;
 /// 实例变量
 typedef struct objc_ivar *Ivar;
 /// 类别Category
 typedef struct objc_category *Category;
 /// 类中声明的属性
 typedef struct objc_property *objc_property_t;
 
 //类在runtime中的表示
 struct objc_class {
 Class isa;//指针，顾名思义，表示是一个什么，
 //实例的isa指向类对象，类对象的isa指向元类
 #if !__OBJC2__
 Class super_class;  //指向父类
 const char *name;  //类名
 long version;
 long info;
 long instance_size
 struct objc_ivar_list *ivars //成员变量列表
 struct objc_method_list **methodLists; //方法列表
 struct objc_cache *cache;//缓存
 //一种优化，调用过的方法存入缓存列表，下次调用先找缓存
 struct objc_protocol_list *protocols //协议列表
 #endif
 } OBJC2_UNAVAILABLE;
 */

@interface TestObj : NSObject<UITableViewDelegate, UITableViewDataSource> {
    NSInteger       _int;
    NSString        *_string;
    NSNumber        *_number;
}
#pragma mark - < Property >
@property (nonatomic, copy) NSString            *stringPre;
@property (nonatomic, strong) NSNumber          *numberPre;
@property (nonatomic, assign) NSInteger         intPre;

#pragma mark - < Method >
- (void)getPropertyNames;

- (void)getIvarNames;

- (void)getMethodNames;

- (void)getProtocolNames;
@end



