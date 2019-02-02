//
//  SlideViewController.m
//  RACDemo
//
//  Created by njw on 2019/2/1.
//  Copyright © 2019 njw. All rights reserved.
//

#import "SlideViewController.h"

@interface SlideViewController ()
@property (weak, nonatomic) IBOutlet UISlider *r_slider;
@property (weak, nonatomic) IBOutlet UISlider *g_slider;
@property (weak, nonatomic) IBOutlet UISlider *b_slider;
@property (weak, nonatomic) IBOutlet UITextField *r_textfield;
@property (weak, nonatomic) IBOutlet UITextField *g_textfield;
@property (weak, nonatomic) IBOutlet UITextField *b_textfield;
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.r_textfield.text = self.g_textfield.text = self.b_textfield.text = @"0.5";
    RACSignal *redSignal = [self bindSlider:self.r_slider textField:self.r_textfield];
    RACSignal *greenSignal = [self bindSlider:self.g_slider textField:self.g_textfield];
    RACSignal *blueSignal = [self bindSlider:self.b_slider textField:self.b_textfield];
    
    //第一种方式
//    [[[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id(RACTuple * _Nullable x) {
//        return [UIColor colorWithRed:[x[0] floatValue] green:[x[1] floatValue] blue:[x[2] floatValue] alpha:1];
//    }] subscribeNext:^(id  _Nullable x) {
//        // 此处一般不是主线程
//        dispatch_async(dispatch_get_main_queue(), ^{
//           self.showView.backgroundColor = x;
//        });
//    }];
    
    //第二种方式
    RACSignal *changeValueSignal = [[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id(RACTuple * _Nullable x) {
        return [UIColor colorWithRed:[x[0] floatValue] green:[x[1] floatValue] blue:[x[2] floatValue] alpha:1];
    }];
    
    RAC(_showView, backgroundColor) = changeValueSignal;
}

- (RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField {
    
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:signalSlider];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalText];
    
    return [[signalText merge:signalSlider] merge:textSignal];
}

@end
