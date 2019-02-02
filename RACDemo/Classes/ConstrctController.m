//
//  ConstrctController.m
//  RACDemo
//
//  Created by njw on 2019/2/1.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ConstrctController.h"

@interface ConstrctController ()

@end

@implementation ConstrctController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self signalFromJson:@"http://localhost:8080/login"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x[@"data"]);
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    
    RACSignal *s1 = [self signalFromJson:@"http://localhost:8080/login"];
    RACSignal *s2 = [self signalFromJson:@"http://localhost:8080/login"];
    RACSignal *s3 = [self signalFromJson:@"http://localhost:8080/login"];
    
    //并行
    [[s1 merge:s2] merge:s3];
    
    //串行
    [[[s1 then:^RACSignal * _Nonnull{
        return s2;
    }] then:^RACSignal * _Nonnull{
        return s3;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    //同步等待 (三个信号并行执行，都完成后交给订阅者)
    [[RACSignal combineLatest:@[s1, s2,s3]] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
}

- (RACSignal *)signalFromJson:(NSString *)urlStr {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:c];
        NSURLSessionDataTask *data = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                NSError *e;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                if (e) {
                    [subscriber sendError:e];
                }
                else {
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
            }
        }];
        [data resume];
        
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
