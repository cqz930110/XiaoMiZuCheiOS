//
//  HLPickView.h
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickView;
typedef void (^HLPickViewSubmit)(NSString*,NSDate *);

@interface ZHPickView : UIView<UIPickerViewDelegate>

- (void)setDateViewWithTitle:(NSString *)title;

- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title;
- (void)showPickView:(UIViewController *)vc;
- (void)showWindowPickView:(UIWindow *)window;

@property(nonatomic, copy) ZCStringBlock block;
@property(nonatomic, copy) HLPickViewSubmit alertBlock;

@end
