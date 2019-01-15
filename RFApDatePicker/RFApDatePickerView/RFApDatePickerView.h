//
//  RFApDatePickerView.h
//  RFApDatePicker
//
//  Created by 冯剑 on 2019/1/15.
//  Copyright © 2019 rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^myBlock)(NSString *dateStr);

@interface RFApDatePickerView : UIView
@property (nonatomic, copy) myBlock selectedBlock;
+ (instancetype)showPickerViewDateBlock:(myBlock)dateBlock;

@end

NS_ASSUME_NONNULL_END
