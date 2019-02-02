//
//  ViewController.m
//  RACDemo
//
//  Created by njw on 2019/2/1.
//  Copyright © 2019 njw. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UITextField *userTextField;
    @property (weak, nonatomic) IBOutlet UITextField *pwdTextFeild;
    @property (weak, nonatomic) IBOutlet UIButton *loginBtn;
    
@end

@implementation LoginViewController
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.userTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
//    RACSignal *enableSignal = [self.userTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length > 0);
//    }];
    
    
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.userTextField.rac_textSignal, self.pwdTextFeild.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value[0] length] >0 && [value[1] length] > 6);
    }];
    
    self.loginBtn.rac_command = [[RACCommand alloc]  initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

    
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    return YES;
//}
    
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    //在一次注册中调用零次或多次
    [viewDidAppearSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        NSLog(@"%s", __func__);
    }];
    // 成功回调 与下面的失败回调 互斥 在一次注册中 只调用一次
    [viewDidAppearSignal subscribeCompleted:^{
        
    }];
    //
    [viewDidAppearSignal subscribeError:^(NSError * _Nullable error) {
        
    }];
    
    //Action
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[[NSDate date] description]];
                
                [subscriber sendCompleted];
            });
            
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }]];
    
    [[[button rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
        }];
    }];
            
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setBounds:CGRectMake(100, 100, 100, 100)];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSLog(@"%s", __func__);
}
*/
@end
