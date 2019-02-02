//
//  ViewController.m
//  RACDemo
//
//  Created by njw on 2019/2/2.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[@"",@"",@"",@"",@""];
}

@end
