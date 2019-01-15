//
//  ViewController.m
//  RFApDatePicker
//
//  Created by 冯剑 on 2019/1/15.
//  Copyright © 2019 rocky. All rights reserved.
//

#import "ViewController.h"
#import "RFApDatePickerView.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIButton *_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 40)];
    btn.backgroundColor = [UIColor cyanColor];
    [btn setTitle:@"选择我预约日期" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
}


- (void)showDatePickerView{
    [RFApDatePickerView showPickerViewDateBlock:^(NSString *dateStr) {
        [self->_btn setTitle:dateStr forState:UIControlStateNormal];
    }];
}

@end
