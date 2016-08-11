//
//  FDAlertView.m
//  GNETS
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FDAlertView.h"


#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

@interface FDAlertView()

@property (nonatomic, copy) NSString *tit;
@property (nonatomic, copy) NSString *msg;

@end

@implementation FDAlertView
- (id)initWithFrame:(CGRect)frame withTit:(NSString *)tit withMsg:(NSString *)msg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        _tit = tit;
        _msg = msg;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 140)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.borderWidth = 1;
        self.zd_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.zd_superView.layer.cornerRadius = 5.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        
        UIWindow *window = [QZManager getWindow];
        [window addSubview:self];
        
        [self initUI];
        
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, zd_width-100, 20)];
    headlab.text = _tit;
    headlab.textAlignment = NSTextAlignmentCenter;
    headlab.font = Font_18;
    headlab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.zd_superView addSubview:headlab];

    
    UILabel *msglab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(headlab) +15, zd_width-130, 40)];
    msglab.text = _msg;
    msglab.textAlignment = NSTextAlignmentCenter;
    msglab.font = Font_15;
    msglab.numberOfLines = 0;
    msglab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.zd_superView addSubview:msglab];

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor whiteColor];
    sureBtn.titleLabel.font = Font_16;
    sureBtn.frame = CGRectMake(15.f, Orgin_y(msglab) +5, zd_width - 130 , 40);
    [sureBtn setTitle:@"确定" forState:0];

    [sureBtn setTitleColor:LRRGBAColor(49, 120, 250, 1) forState:0];
    [sureBtn addTarget:self action:@selector(cancelOrSureEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.zd_superView addSubview:sureBtn];
    
}
- (void)cancelOrSureEvent{
    
    _navBlock();
    [self zd_Windowclose];
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.zd_superView.center = CGPointMake(zd_width/2.0,-300);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
