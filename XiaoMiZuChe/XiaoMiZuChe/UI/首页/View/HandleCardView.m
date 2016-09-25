//
//  HandleCardView.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HandleCardView.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height
#define MONEYBTNWIDTH ([UIScreen mainScreen].bounds.size.width - 90.f)/3.f
@interface HandleCardView()

@property (nonatomic, strong) UIView *zd_superView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, copy)   NSString *moneyString;//年费
@end

@implementation HandleCardView

- (id)initWithFrame:(CGRect)frame WithMoney:(NSString *)money
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.moneyString = money;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        [self initUI];
    }
    return self;
}
#pragma mark - private methods
- (void)initUI{
    WEAKSELF;
    [self addSubview:self.zd_superView];
    [self.zd_superView addSubview:self.titleLab];
    
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.zd_superView.frame = CGRectMake(0, zd_height - 200, zd_width, 200);
    }];
    
    NSArray *imageArr = @[@"bg_wxpay",@"bg_alipay",@"bg_unionpay"];
    for (NSInteger index = 0; index <imageArr.count; index ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + (30 + MONEYBTNWIDTH)*index , 70, MONEYBTNWIDTH, 110);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:kGetImage(imageArr[index]) forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.tag = 2000 + index;
        [btn addTarget:self action:@selector(selectPayEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.zd_superView addSubview:btn];
    }
    
    [self whenCancelTapped:^{
        [self zd_Windowclose];
    }];
    [self.zd_superView  whenCancelTapped:^{
        
    }];
}
#pragma mark - event response
- (void)selectPayEvent:(UIButton *)btn
{
    NSInteger index = btn.tag -2000;
    if ([self.delegate respondsToSelector:@selector(choiceOfPaymentWithIndex:)]) {
        [self.delegate choiceOfPaymentWithIndex:index];
    }
    [self zd_Windowclose];
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:.3f];
    self.alpha = 0.0;
    [UIView commitAnimations];
    [self removeFromSuperview];
}

#pragma mark - setters and getters
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        _zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, zd_height, zd_width, 200)];
        _zd_superView.backgroundColor = [UIColor whiteColor];
    }
    return _zd_superView;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, zd_width - 30, 20)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = Font_15;
        _titleLab.textColor = hexColor(F8B62A);
        _titleLab.text = [NSString stringWithFormat:@"支付年费：¥%@",_moneyString];
    }
    return _titleLab;
}
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(self.zd_superView)
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
