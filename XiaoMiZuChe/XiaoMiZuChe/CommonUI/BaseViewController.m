//
//  BaseViewController.m
//  GNETS
//
//  Created by tcnj on 16/2/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BaseViewController.h"
#define TitleFont 18.0f
#define LeftFont 13.0f
#define kDefaultWidth   44.0
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseViewController ()
{
    CGFloat barSpacing;
}

@end

@implementation BaseViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        //
        barSpacing = 0.0;
    }
    return self;
}
#pragma mark - getters and setters
- (UIView *)statusBarView
{
    if (!_statusBarView) {
        CGRect frame = CGRectZero;
        // The status bar default color by red color.
        frame = CGRectMake(0.0, 0.0, kMainScreenWidth, barSpacing);
        _statusBarView = [[UIView alloc] initWithFrame:frame];
        [_statusBarView setBackgroundColor:KNavigationBarColor];
    }
    return _statusBarView;
}
- (UIView *)naviBarView
{
    if (!_naviBarView) {
        CGRect frame = CGRectZero;
        // The status bar default color by red color.
        frame = CGRectMake(0.0, barSpacing, kMainScreenWidth, kDefaultWidth);
        _naviBarView = [[UIView alloc] initWithFrame:frame];
        [_naviBarView setBackgroundColor:KNavigationBarColor];
    }
    return _naviBarView;
}
-(UIButton *)leftBtn
{
    if (!_leftBtn) {
        CGRect frame = CGRectMake(0.0, 0.0, kDefaultWidth, kDefaultWidth);
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = frame;
        [_leftBtn addTarget:self
                         action:@selector(handleBtnAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setTag:NaviLeftBtn];
        [_leftBtn setHidden:YES];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        CGRect frame = CGRectMake(CGRectGetWidth(_naviBarView.bounds) - kDefaultWidth, 0.0, kDefaultWidth, kDefaultWidth);
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = frame;
        [self.rightBtn addTarget:self
                          action:@selector(handleBtnAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn setTag:NaviRightBtn];
        [self.rightBtn setHidden:YES];
    }
    return _rightBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGRect frame = CGRectMake(0.0, 0.0, 0.0, kDefaultWidth);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:THIRDCOLOR];
    }
    return _titleLabel;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(delayInitialLoading) withObject:nil afterDelay:0.05];
    
    //隐藏手势的导航栏
    self.fd_prefersNavigationBarHidden = YES;


    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        barSpacing = 20.0;
        [self.view addSubview:self.statusBarView];
    }
    
    // init navi bar
    [self.view addSubview:self.naviBarView];
    
    // Left button
    [self.naviBarView addSubview:self.leftBtn];
    
    // Right button
    [self.naviBarView addSubview:self.rightBtn];
    
    // Title label
    [self.naviBarView addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.4, kMainScreenWidth, .6f)];
    lineView.backgroundColor = hexColor(E6E8EA);
    [self.view addSubview:lineView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)delayInitialLoading
{
    //子类使用，延时加载，避免页面卡顿
}
#pragma mark - Public method

- (void)setupStatusBarWithColor:(UIColor *)color
{
    if (![color isEqual:_statusBarView.backgroundColor])
    {
        [self.statusBarView setBackgroundColor:color];
    }
}

- (void)setupStatusBarHidden:(BOOL)hidden {
    [self.statusBarView setHidden:hidden];
}

- (void)setupNaviBarWithColor:(UIColor *)color {
    if (![color isEqual:_naviBarView.backgroundColor]) {
        [self.naviBarView setBackgroundColor:color];
    }
}

- (void)setupNaviBarHidden:(BOOL)hidden {
    [self.naviBarView setHidden:hidden];
}

- (void)setupNaviBarWithTitle:(NSString *)title {
    if (_titleLabel && [title length] > 0) {
        [self.titleLabel setText:title];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TitleFont]];
        
        CGRect frame = _titleLabel.frame;
        frame.size.width = [QZManager getLabelWidth:_titleLabel];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.titleLabel.frame = CGRectMake(60, 0.0, kMainScreenWidth-120.f, 44.f);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGPoint center = CGPointMake(self.naviBarView.center.x, self.naviBarView.center.y - barSpacing);
        [self.titleLabel setCenter:center];
    }
}

- (void)setupNaviBarHiddenBtnWithLeft:(BOOL)left
                                right:(BOOL)right {
    if (left != _leftBtn.isHidden) {
        [self.leftBtn setHidden:left];
    }
    
    if (right != _rightBtn.isHidden) {
        [self.rightBtn setHidden:right];
    }
}

- (void)setupNaviBarWithBackAndTitle:(NSString *)title {
    [self setupNaviBarWithTitle:title];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        [self setupNaviBarWithBtn:NaviLeftBtn
                            title:@""
                              img:@"back"];
    }
}

- (void)setupNaviBarWithBtn:(NaviBarBtn)btnTag
                      title:(NSString *)title
                        img:(NSString *)imgName {
    UIButton *btn = nil;
    if (btnTag == NaviLeftBtn) {
        btn = _leftBtn;
    } else if (btnTag == NaviRightBtn) {
        btn = _rightBtn;
    }
    
    if (!btn) return;
    if ([btn isHidden]) [btn setHidden:NO];
    
    CGRect frame = btn.frame;
    UIImage *image = nil;
    if ([imgName length] > 0) {
        image = [UIImage imageNamed:imgName];
        [btn setImage:image forState:UIControlStateNormal];
        
        frame.size.width = MAX(image.size.width, 44.0);
    }
    
    if ([title length] > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:LeftFont]];
        
        if (image) {
            frame.size.width = image.size.width + [QZManager getLabelWidth:btn.titleLabel] + 20.0;
        } else {
            frame.size.width = [QZManager getLabelWidth:btn.titleLabel] + 20.0;
        }
    }
    
    frame.size.width = MAX(CGRectGetWidth(frame), CGRectGetWidth(btn.frame));
    
    if (btn.tag == NaviRightBtn) {
        frame.origin.x = CGRectGetWidth(_naviBarView.bounds) - CGRectGetWidth(frame);
    }
    
    [btn setFrame:frame];
}

- (void)setupNaviBarWithCustomView:(UIView *)view {
    if (view) {
        //
        [self.titleLabel setHidden:YES];
        
        [self.naviBarView addSubview:view];
    }
}

- (CGFloat)getNaviBarHeight {
    if (_naviBarView && !_naviBarView.isHidden) {
        return barSpacing + CGRectGetHeight(_naviBarView.frame);
    }
    return barSpacing;
}

- (CGFloat)getContentHeight {
    return CGRectGetHeight(self.view.bounds) - [self getNaviBarHeight];
}

- (UIView *)getNaviBarView {
    return self.naviBarView;
}

- (UILabel *)getTitleLabel {
    return self.titleLabel;
}
#pragma mark - Public method

- (void)handleBtnAction:(UIButton *)btn
{
    if (btn.tag == NaviLeftBtn)
    {
        if ([[self.navigationController viewControllers] count] == 1)
        {
            //点击根viewController上面的自定义navBar左侧的按钮时需要进行的操作
            [self leftBtnAction];
        }
        else
        {
            //nav中不止一个Viewcontroller时默认的操作
            [self leftBtnAction];
        }
    }
    else if (btn.tag == NaviRightBtn)
    {
        [self rightBtnAction];
    }
}
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnAction
{
    //子类继承实现
}


@end
