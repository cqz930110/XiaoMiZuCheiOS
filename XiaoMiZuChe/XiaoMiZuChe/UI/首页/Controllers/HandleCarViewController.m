//
//  HandleCarViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HandleCarViewController.h"
#import "HandleCardView.h"

@interface HandleCarViewController ()<HandleCardViewPro>

@property (nonatomic, strong) UIImageView *vipCardImgView;
@property (nonatomic, strong) UIButton *immediatelyBtn;
@property (nonatomic, strong) HandleCardView *payView;

@end

@implementation HandleCarViewController
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_payView);
    TTVIEW_RELEASE_SAFELY(_vipCardImgView);
    TTVIEW_RELEASE_SAFELY(_immediatelyBtn);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBarWithTitle:@"办理租车卡"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];

    [self.view addSubview:self.vipCardImgView];
    [self.view addSubview:self.immediatelyBtn];
    
}
#pragma mark - event respose
- (void)immediatelyToDealWith:(UIButton *)btn
{WEAKSELF;
    DLog(@"立即办理获取年费");
    [APIRequest getVipYearPriceRequestSuccess:^(NSString *moneyString) {
        
        weakSelf.payView = [[HandleCardView alloc] initWithFrame:kMainScreenFrameRect
                                               WithMoney:moneyString];
        weakSelf.payView.delegate = self;
        [self.view addSubview:weakSelf.payView];
        
    } fail:^{
        
    }];
    
}
#pragma mark - HandleCardViewPro
- (void)choiceOfPaymentWithIndex:(NSInteger)index
{
    DLog(@"%ld",index);
}
#pragma mark - getters and setters
- (UIImageView *)vipCardImgView
{
    if (!_vipCardImgView) {
        _vipCardImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 94, kMainScreenWidth -60, (kMainScreenWidth - 60)*170.f/287.f)];
        _vipCardImgView.image = kGetImage(@"pic_vip_card");
    }
    return _vipCardImgView;
}
- (UIButton *)immediatelyBtn
{
    if (!_immediatelyBtn) {
        _immediatelyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyBtn.frame = CGRectMake(30 , Orgin_y(_vipCardImgView) + 30, kMainScreenWidth - 60, 41);
        [_immediatelyBtn setBackgroundColor:hexColor(F08200)];
        [_immediatelyBtn setTitle:@"立即办理" forState:0];
        [_immediatelyBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_immediatelyBtn addTarget:self action:@selector(immediatelyToDealWith:) forControlEvents:UIControlEventTouchUpInside];
        _immediatelyBtn.layer.masksToBounds = YES;
        _immediatelyBtn.layer.cornerRadius = 5.f;
    }
    return _immediatelyBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
