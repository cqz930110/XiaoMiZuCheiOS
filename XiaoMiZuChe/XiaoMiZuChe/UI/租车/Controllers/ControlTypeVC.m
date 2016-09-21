//
//  ControlTypeVC.m
//  GNETS
//
//  Created by cqz on 16/6/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ControlTypeVC.h"
#import "XXBRippleView.h"

@interface ControlTypeVC ()
{
    UIColor *_imgColor;
}

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) XXBRippleView *flaseView;
@property (nonatomic, assign) BOOL isStart;

@end

@implementation ControlTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_lockStr isEqualToString:@"0"])
    {
        _imgColor = LRRGBAColor(236, 99, 80 , 1);
    }else{
        _imgColor = LRRGBAColor(106, 203, 98, 1);
    }
    
    [self initUI];
    //检测是围栏车成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleLockCarStatus:) name:@"OpenVf" object:nil];
}

#pragma -mark 处理是否锁车成功
- (void)handleLockCarStatus:(NSNotification *)sender{
    
    NSString *eventType = [sender.userInfo objectForKey:@"eventType"];
    //1锁车成功 2 锁车失败 3解锁成功 4解锁失败
    if (eventType.intValue == 1) {
        _lockStr = @"1";
    
    }else if(eventType.intValue == 3){
        _lockStr= @"0";

    }else if (eventType.intValue == 2){
        _lockStr = @"0";

    }else if (eventType.intValue == 4){
        _lockStr = @"1";
    }
    
    [self.flaseView stopRippleAnimation];
    [self selectPictureWithControlType];
}
#pragma mark -判断远程控制按钮显示什么样的图片
- (void)selectPictureWithControlType
{
    if ([_lockStr isEqualToString:@"0"])
    {
        _imgColor = LRRGBAColor(106, 203, 98, 1);

    }else{
        _imgColor = LRRGBAColor(236, 99, 80 , 1);

    }
    
    if ([_controlType isEqualToString:@"1"]) {
        // 远程锁车
        if ([_lockStr isEqualToString:@"0"]) {
            // 等于0时候调用锁车的接口
            _bgImgView.image = [UIImage imageNamed:@"icon_lock_open"];
            
        }else {
            //等于1时候调用的是解锁的接口
            _bgImgView.image =  [UIImage imageNamed:@"icon_lock_close"];
        }
    }else if ([_controlType isEqualToString:@"2"]){
        // 语音寻车
        if ([_lockStr isEqualToString:@"0"]) {
            // 等于0时候调用锁车的接口
            _bgImgView.image = [UIImage imageNamed:@"icon_sound_open"];
            
        }else {
            //等于1时候调用的是解锁的接口
            _bgImgView.image = [UIImage imageNamed:@"icon_sound_close"];
        }
        
    }else{
        // 一键启动
        if ([_lockStr isEqualToString:@"0"]) {
            // 等于0时候调用锁车的接口
            _bgImgView.image = [UIImage imageNamed:@"icon_onekey_open"];
            
        }else {
            //等于1时候调用的是解锁的接口
            _bgImgView.image = [UIImage imageNamed:@"icon_onekey_close"];
        }
    }
}

- (void)initUI{
    
    [self setupNaviBarWithBtn:NaviLeftBtn
                        title:@"卫星定位"
                          img:@"icon_left_arrow"];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, kMainScreenHeight - 70, kMainScreenWidth - 60.f, 40)];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.font = Font_14;
    [self.view addSubview:lab];
    
    if ([_controlType isEqualToString:@"1"]) {
        [self setupNaviBarWithTitle:@"远程锁车"];
        lab.text = @"此功能只有设备端远程控制线为远程锁车才支持";
        
    }else if ([_controlType isEqualToString:@"2"]){
        [self setupNaviBarWithTitle:@"语音寻车"];
        lab.text = @"此功能只有设备端远程控制线为语音寻车才支持";
        
    }else {
        [self setupNaviBarWithTitle:@"一键启动"];
        lab.text = @"此功能只有设备端远程控制线为一键启动才支持";
    }

    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.center = self.view.center;
    _bgImgView.bounds = CGRectMake(0, 0, 180, 180);
    [self.view addSubview:_bgImgView];
    
    [self selectPictureWithControlType];
    
    [self creatView];
}
#pragma mark - 创建UIView
- (void)creatView
{WEAKSELF;
    
    
    _flaseView = [[XXBRippleView alloc] init];
    _flaseView.center = self.view.center;
    _flaseView.bounds = CGRectMake(0, 0, 180, 180);
    _flaseView.backgroundColor = [UIColor clearColor];
    _flaseView.maxRadius = kMainScreenWidth - 100.f;
    _flaseView.minRadius = 90.f;

    _flaseView.rippleColor = _imgColor;
    [_flaseView whenCancelTapped:^{
        
        if (!weakSelf.isStart) {
            [weakSelf.flaseView startRippleAnimation];
            [weakSelf CallToLockTheCar];
        }else{
            [weakSelf.flaseView stopRippleAnimation];
        }
        
        weakSelf.isStart = !weakSelf.isStart;

    }];
    [self.view addSubview:_flaseView];

}
- (void)CallToLockTheCar
{WEAKSELF;
    NSString *typeStr = [NSString stringWithFormat:@"%d",[_controlType intValue] - 1];
    if ([_lockStr isEqualToString:@"0"]) {
        //等于0时候调用锁车的接口
        [NetWorkMangerTools lockCarWithPara:typeStr RequestSuccess:^{
            
//            [weakSelf.flaseView stopRippleAnimation];

        } fail:^{
            [weakSelf.flaseView stopRippleAnimation];

        }];
        
    }else{
        //等于1时候调用的是解锁的接口
        [NetWorkMangerTools unlockCarWithPara:typeStr RequestSuccess:^{

//            [weakSelf.flaseView stopRippleAnimation];

        } fail:^{
            [weakSelf.flaseView stopRippleAnimation];

        }];
    }
}
#pragma mark -连续点击取消
- (void)cancelCallToLockTheCar
{WEAKSELF;
    NSString *typeStr = [NSString stringWithFormat:@"%d",[_controlType intValue] - 1];

    if ([_lockStr isEqualToString:@"0"]) {
        [NetWorkMangerTools unlockCarWithPara:typeStr RequestSuccess:^{
            
//            [weakSelf.flaseView stopRippleAnimation];
        } fail:^{
            [weakSelf.flaseView stopRippleAnimation];
        }];

    }else{
        [NetWorkMangerTools lockCarWithPara:typeStr RequestSuccess:^{
//            [weakSelf.flaseView stopRippleAnimation];

        } fail:^{
            [weakSelf.flaseView stopRippleAnimation];
        }];
    }

    
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
