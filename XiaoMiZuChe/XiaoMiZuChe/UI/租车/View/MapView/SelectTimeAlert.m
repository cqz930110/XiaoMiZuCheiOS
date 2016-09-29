//
//  SelectTimeAlert.m
//  GNETS
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define Orgin_y(container)   (container.frame.origin.y+container.frame.size.height)
#define Orgin_x(container)   (container.frame.origin.x+container.frame.size.width)

#import "SelectTimeAlert.h"
#import "SelectTimeCell.h"
#import "ZHPickView.h"
#import "trackModel.h"
#import "carRecord.h"

static  NSString * const CellIdentifier  = @"couponIdentifier";
@interface SelectTimeAlert()
{
    NSDate *_nowDate;
    NSDate *_yesterDate;
}

@property (nonatomic,copy) NSString *nowString;
@property (nonatomic,copy) NSString *yesterString;
@property (strong, nonatomic) UIWindow *window;

@end
@implementation SelectTimeAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        self.backgroundColor = [UIColor clearColor];
        
        [self whenTapped:^{
            [UIView animateWithDuration:0.2 animations:^{
                [self removeFromSuperview];
            }];
        }];
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.layer.cornerRadius = 10;
        _backgroundView.center = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT/2.f);
        _backgroundView.bounds = CGRectMake(0, 0, 260, 180);
        [self addSubview:_backgroundView];
        [_backgroundView whenCancelTapped:^{
            
            
        }];

        float width = _backgroundView.frame.size.width;
        float height = _backgroundView.frame.size.height;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 20,width-10, height - 80) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = YES;
        _tableView.layer.cornerRadius = 15.f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_backgroundView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectTimeCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 139, width, .5)];
        lineView.backgroundColor = LRRGBAColor(219, 219, 223, 1);
        [_backgroundView addSubview:lineView];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView.frame.size.width/2.f, Orgin_y(lineView), .5, 40)];
        lineView2.backgroundColor = LRRGBAColor(219, 219, 223, 1);
        [_backgroundView addSubview:lineView2];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [cancelBtn setTitleColor:LRRGBAColor(49, 120, 250, 1) forState:0];
        [cancelBtn setTitle:@"取消" forState:0];
        cancelBtn.tag = 3873;
        [cancelBtn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.frame = CGRectMake(0, Orgin_y(lineView),width-Orgin_x(lineView2), height-Orgin_y(lineView));
        [_backgroundView addSubview:cancelBtn];
        
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = [UIColor whiteColor];
        sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [sureBtn setTitleColor:LRRGBAColor(49, 120, 250, 1) forState:0];
        [sureBtn setTitle:@"确认" forState:0];
        sureBtn.tag = 3874;
        [sureBtn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.frame = CGRectMake(Orgin_x(lineView2), Orgin_y(lineView),width-Orgin_x(lineView2)-0.5, height-Orgin_y(lineView));
        [_backgroundView addSubview:sureBtn];
        
        
    }
    return self;
}

- (void)btnClickEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
    
    if (index == 3874)
    {
        
        NSUInteger day = [QZManager getDaysFrom:_yesterDate To:_nowDate];
        DLog(@"时间: %lu",(unsigned long)day);
        
        if (day > 6) {
            [JKPromptView showWithImageName:nil message:@"最多可查询一周轨迹，请修改时间范围"];
            return;
        }
        
        NSString *carIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.carRecord.carId];
        NSString *userIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];
        NSString *searchUrl = [NSString stringWithFormat:@"%@%@?carId=%@&userId=%@&startTime=%@&endTime=%@",kProjectBaseUrl,SEARCHTRACK,carIdString,userIdString,_yesterString,_nowString];
        [ZhouDao_NetWorkManger GetJSONWithUrl:[searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isNeedHead:YES success:^(NSDictionary *jsonDic) {
            
            NSUInteger code = [[jsonDic objectForKey:@"code"] integerValue];
            NSString *msg = jsonDic[@"errmsg"];
            if (code != 1) {
                [JKPromptView showWithImageName:nil message:msg];
                return;
            }
            
            trackModel *model = [[trackModel alloc] initWithDictionary:jsonDic];
            NSMutableArray *arrays = [NSMutableArray array];
            arrays = [model.data mutableCopy];
            
            
            trackdata *data0 = model.data[0];
            NSUInteger lat0 = [data0.lat integerValue];
            NSUInteger lon0 = [data0.lon integerValue];
            CLLocationCoordinate2D center0 = {lat0/1000000.0, lon0/1000000.0};
            
            trackdata *data1 = model.data[model.data.count-1];
            NSUInteger lat1 = [data1.lat integerValue];
            NSUInteger lon1 = [data1.lon integerValue];
            CLLocationCoordinate2D center1 = {lat1/1000000.0, lon1/1000000.0};

            if ([self.delegate respondsToSelector:@selector(ShowTheRoadWithKSDate:WithStar:withEnd:)])
            {
                [self.delegate ShowTheRoadWithKSDate:arrays WithStar:center0 withEnd:center1];
            }

            
            
        } fail:^{
            
        }];
        
        
    }
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTimeCell *cell = (SelectTimeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kMainScreenWidth , .5)];
    lineView.backgroundColor = LRRGBAColor(235, 235, 236, 1);
    [cell.contentView addSubview:lineView];

    indexPath.row == 0 ? [cell.ksLab setText:@"开始时间"]:[cell.ksLab setText:@"结束时间"];
    
    if (_nowString.length>0) {
        indexPath.row == 0 ? [cell.dateLab setText:_yesterString]:[cell.dateLab setText:_nowString];
    }else{
        NSDate *nowDate =[NSDate date];
        _nowDate = nowDate;
        NSDate *yesterDay = [NSDate dateWithTimeIntervalSinceNow:-1*24*60*60];
        //    NSTimeInterval secondsPerDay1 = -24*60*60;
        //   // NSDate *yesterDay = [nowDate addTimeInterval:secondsPerDay1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *nowString = [formatter stringFromDate:nowDate];
        NSString *yesterDayString = [formatter stringFromDate:yesterDay];
        
        _nowString = [NSString stringWithFormat:@"%@",nowString];
        _yesterString = [NSString stringWithFormat:@"%@",yesterDayString];
        
        indexPath.row == 0 ? [cell.dateLab setText:yesterDayString]:[cell.dateLab setText:nowString];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDateViewWithTitle:@"选择时间"];
    [pickView showWindowPickView:self.window];
    pickView.alertBlock = ^(NSString *selectedStr,NSDate *_selectDate)
    {
        if (indexPath.row == 0) {
            _yesterString = selectedStr;
            _yesterDate = _selectDate;
        }else{
            _nowString = selectedStr;
            _nowDate = _selectDate;
        }
        [_tableView  reloadData];
        DLog(@"时间是－－－－%@",selectedStr);
        
    };
}
- (void)show
{
    UIWindow *window = [QZManager getWindow];
    self.window = window;
    [window addSubview:self];
    [self showAlertAnimation];
}
-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
