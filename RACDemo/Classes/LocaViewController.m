//
//  LocaViewController.m
//  RACDemo
//
//  Created by njw on 2019/2/2.
//  Copyright © 2019 njw. All rights reserved.
//

#import "LocaViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocaViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation LocaViewController

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (RACSignal *)authorizedSignal {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
        
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return @([value[1] integerValue] == kCLAuthorizationStatusAuthorizedAlways);
        }];
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    RACSignal *signal = RACObserve(self, title);
//
//    [signal subscribeNext:^(id  _Nullable x) {
//
//    }];
//    RAC() = RACObserve(<#TARGET#>, <#KEYPATH#>) 绑定属性
    
    
    RACSignal *locationSignal = [[[[[self authorizedSignal] filter:^BOOL(id  _Nullable value) {
        //判断是否有权限
        return [value boolValue];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value){
        //监听地址刷新的状态
        return [[[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            return value[1];
            //混合错误监听
        }] merge:[[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            //返回错误
            return [RACSignal error:value[1]];
        }]] take:1] initially:^{
            //initially 在所有之前开始
            [self.manager startUpdatingLocation];
        }] finally:^{
            //finally 处理完之后
            [self.manager stopUpdatingLocation];
        }];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            CLLocation *location = [value firstObject];
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    [subscriber sendError:error];
                }else{
                    [subscriber sendNext:[placemarks firstObject]];
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        self.placeLabel.text = [x addressDictionary][@"Name"];
    }];
}

@end
