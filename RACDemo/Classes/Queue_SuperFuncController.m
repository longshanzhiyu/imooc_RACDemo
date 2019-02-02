//
//  Queue_SuperFuncController.m
//  RACDemo
//
//  Created by njw on 2019/2/2.
//  Copyright © 2019 njw. All rights reserved.
//

#import "Queue_SuperFuncController.h"

@interface Queue_SuperFuncController ()

@end

@implementation Queue_SuperFuncController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //push-driven  //pull-driven
    //推           //拉
    
    __block int a = 10;
    RACSignal *s = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        a+=5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLast];
    
    //side effect 副作用 重复订阅两次信号 信号内的代码重复执行 调用replayLast 可以解决
    [s subscribeNext:^(id  _Nullable x) {
        // 15
        NSLog(@"%@", x);
    }];
    
    [s subscribeNext:^(id  _Nullable x) {
        // 20
        NSLog(@"%@", x);
    }];
    
    // RACSequence RACSequence / RACStream
    // 与RACSignal的区别是 RACSignal是拉驱动型的信号量 而RACSequence是推驱动型的信号量
    // 推驱动型的信号量 在初始化的时候 其内容就已经定义好了 而拉信号只有在订阅时才生成内容 两者之间可以相互转化
    
    RACSequence *seq = [s sequence];
    [seq signal];
    
    NSArray *arr = @[@(1),@(2),@(3),@(4),@(5)];
    RACSequence *se = [arr rac_sequence];
    [se array];
    
    //map, filter, flattenMap, concat...
    
    //sequence 虽然等同于NSArray 但是直接对其打印 无法输出 因为它默认是惰性初始化的 只有在访问其内容时 才会初始化 这样可以避免内存资源的浪费 所以在此 转回array 才可以打印出
    NSLog(@"%@", [[se map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] *3);
    }] array]);
    
    NSLog(@"%@", [[se filter:^BOOL(id  _Nullable value) {
        return [value integerValue] %2 == 1;
    }] array]);
    
    
    //then与concat 类似 但是 区别在于 前者 x只返回s22的结果 而 后者全部返回
    RACSignal *s11;
    RACSignal *s22;
    [[s11 then:^RACSignal * _Nonnull{
        return s22;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [[s11 concat:s22] subscribeNext:^(id  _Nullable x) {
        
    }];
    
}



@end
