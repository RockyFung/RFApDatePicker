//
//  RFApDatePickerView.m
//  RFApDatePicker
//
//  Created by 冯剑 on 2019/1/15.
//  Copyright © 2019 rocky. All rights reserved.
//

#import "RFApDatePickerView.h"

/**屏幕宽度*/
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
/**屏幕高度*/
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define FitValue(value) ((value) / 375.0) * [UIScreen mainScreen].bounds.size.width

/**颜色*/
#define RFColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HeaderViewHeight FitValue(45)
#define FORMAT @"yyyy-MM-dd"

typedef NS_OPTIONS (NSInteger, HeaderViewButtonType) {
    HeaderViewButtonTypeCancel,
    HeaderViewButtonTypeConfirm
};

@interface RFApDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
///容器view
@property (nonatomic, weak) UIView *containView;
///pickerView
@property (nonatomic, weak) UIPickerView *pickerView;
// dateSource
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *dateDic;

@end

static RFApDatePickerView *_view = nil;

@implementation RFApDatePickerView{
    NSString *_selectedDayStr;
    NSString *_selectedHourStr;
    NSString *_selectedMinStr;
}

- (NSMutableDictionary<NSString *, NSArray *> *)dateDic{
    if (_dateDic == nil) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    return _dateDic;
}

+ (instancetype)showPickerViewDateBlock:(myBlock)dateBlock {
    _view = [[RFApDatePickerView alloc] init];
    //显示view
    _view.selectedBlock = dateBlock;
    [_view pickerViewShow];
    return _view;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        
        [self createUI];
    }
    return self;
}



- (void)createUI{
    UIView *containView = [[UIView alloc] init];
    containView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, FitValue(45+220));
    [self addSubview:containView];
    self.containView = containView;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, ScreenWidth, HeaderViewHeight);
    toolBar.backgroundColor = RFColor(0xf6f6f6);
    [containView addSubview:toolBar];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitValue(100), HeaderViewHeight)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RFColor(0x666666) forState:UIControlStateNormal];
    cancelBtn.tag = HeaderViewButtonTypeCancel;
    [toolBar addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-FitValue(100), 0, FitValue(100), HeaderViewHeight)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:RFColor(0x666666) forState:UIControlStateNormal];
    confirmBtn.tag = HeaderViewButtonTypeConfirm;
    [toolBar addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(0, toolBar.frame.size.height, ScreenWidth, FitValue(220));
    pickerView.backgroundColor = RFColor(0xffffff);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containView addSubview:pickerView];
    self.pickerView = pickerView;
    
    [self refreshDateDictWithRow:0 component:0];
    _selectedDayStr = [NSString stringWithFormat:@"%@",self.dateDic[@"0"][0]];
    _selectedHourStr = [NSString stringWithFormat:@"%@",self.dateDic[@"1"][0]];
    _selectedMinStr = [NSString stringWithFormat:@"%@",self.dateDic[@"2"][0]];
}


- (void)dateChanged:(UIDatePicker *)pickerView {
    NSLog(@"==> %@", pickerView.date);
}

- (void)buttonClick:(UIButton *)sender {
    
    [self pickerViewHiden];
    
    if (sender.tag == HeaderViewButtonTypeConfirm) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:FORMAT];
//        NSString *strDate = [dateFormatter stringFromDate:self.pickerView.date];
        
        if (self.selectedBlock) {
            self.selectedBlock(_selectedDayStr, [_selectedHourStr integerValue], [_selectedMinStr integerValue]);
        }
    }
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dateDic[@"0"].count;
    }else if(component == 1){
        return self.dateDic[@"1"].count;
    }else{
        return self.dateDic[@"2"].count;
    }
}

#pragma mark - UIPickerViewDelegate
// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 100;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *com = [NSString stringWithFormat:@"%ld",(long)component];
    return self.dateDic[com][row];
}
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//}
// attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self refreshDateDictWithRow:row component:component];

    __block BOOL contains = NO;
    if (component == 0) {
        _selectedDayStr = [NSString stringWithFormat:@"%@",self.dateDic[@"0"][row]];
        
        // 遍历数据，如果存在就选择这个日期
        [self.dateDic[@"1"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self->_selectedHourStr isEqualToString:title]) {
                [pickerView selectRow:idx inComponent:1 animated:NO];
                contains = YES;
                *stop = YES;
            }
        }];
        // 如果不存在就取第一个日期
        if (!contains) {
            [pickerView selectRow:0 inComponent:1 animated:NO];
            self->_selectedHourStr = [NSString stringWithFormat:@"%@",self.dateDic[@"1"][0]];
        }
        
        contains = NO;
        [self.dateDic[@"2"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self->_selectedMinStr isEqualToString:title]) {
                [pickerView selectRow:idx inComponent:2 animated:NO];
                contains = YES;
                *stop = YES;
            }
        }];
        if (!contains) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
            self->_selectedMinStr = [NSString stringWithFormat:@"%@",self.dateDic[@"2"][0]];
        }
    }else if(component == 1){
        _selectedHourStr = [NSString stringWithFormat:@"%@",self.dateDic[@"1"][row]];

        contains = NO;
        [self.dateDic[@"2"] enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self->_selectedMinStr isEqualToString:title]) {
                [pickerView selectRow:idx inComponent:2 animated:NO];
                contains = YES;
                *stop = YES;
            }
        }];
        
        if (!contains) {
            [pickerView selectRow:0 inComponent:2 animated:NO];
            self->_selectedMinStr = [NSString stringWithFormat:@"%@",self.dateDic[@"2"][0]];
        }
    }else{
        _selectedMinStr = [NSString stringWithFormat:@"%@",self.dateDic[@"2"][row]];
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@-%@-%@",_selectedDayStr, _selectedHourStr, _selectedMinStr]);
}


// 刷新显示
- (void)refreshDateDictWithRow:(NSInteger)row component:(NSInteger)component{
    // 系统现在时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    
    // 23点49分之后显示第二天
    if (hour == 23 && minute > 49) {
        self.dateDic[@"0"] = @[@"明天", @"后天"];
        self.dateDic[@"1"] = [self getHoursArrayWithMin:0];
        self.dateDic[@"2"] = [self getMinsArrayWithMin:0];
        [self.pickerView reloadAllComponents];
        return;
    }else{
        self.dateDic[@"0"] = @[@"今天",@"明天", @"后天"];
    }
    
    if (component == 0) {
        if (row == 0 ) {
            // 今天
            NSInteger h = hour;
            NSInteger m = minute/10.0+2;
            if (m > 5) {
                // 当分钟数超过50，则从下个小时显示
                h = hour+1;
                m = 0;
            }
            self.dateDic[@"1"] = [self getHoursArrayWithMin:(int)h];
            self.dateDic[@"2"] = [self getMinsArrayWithMin:(int)m];
        }else{
            self.dateDic[@"1"] = [self getHoursArrayWithMin:0];
            self.dateDic[@"2"] = [self getMinsArrayWithMin:0];
        }
        
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        
    }else if(component == 1){
        if (row == 0 && ([_selectedDayStr isEqualToString:@"今天"]||_selectedDayStr==nil)) {
            NSInteger m = minute/10+2;
            if (m > 5) {
                // 当分钟数超过50，分钟从0算
                m = 0;
            }
            self.dateDic[@"2"] = [self getMinsArrayWithMin:(int)m];
        }else{
            self.dateDic[@"2"] = [self getMinsArrayWithMin:0];
        }
        [self.pickerView reloadComponent:2];
    }

}


- (NSArray *)getHoursArrayWithMin:(int)min{
    if (min > 23) {
        return nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = min; i < 24; i++) {
        [temp addObject:[NSString stringWithFormat:@"%.2d点",i]];
    }
    return [temp copy];
}

- (NSArray *)getMinsArrayWithMin:(int)min{
    if (min > 5) {
        return nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = min; i < 6; i++) {
        [temp addObject:[NSString stringWithFormat:@"%.2d分",i*10]];
    }
    return [temp copy];
}

//显示
- (void)pickerViewShow{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        CGRect f = self.containView.frame;
        f.origin.y = ScreenHeight - f.size.height;
        self.containView.frame = f;
    }];
}

//隐藏
- (void)pickerViewHiden {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        CGRect f = self.containView.frame;
        f.origin.y = ScreenHeight;
        self.containView.frame = f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
