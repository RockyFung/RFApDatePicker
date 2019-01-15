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
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 200, 40)];
    [btn setTitle:@"预约日期" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
}


- (void)showDatePickerView{
    [RFApDatePickerView showPickerViewDateBlock:^(NSString *day, NSInteger hour , NSInteger minute) {
        [self->_btn setTitle:[NSString stringWithFormat:@"%@-%ld-%ld",day,hour,minute] forState:UIControlStateNormal];
    }];
}

@end
