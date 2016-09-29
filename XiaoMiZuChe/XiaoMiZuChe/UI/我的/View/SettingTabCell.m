//
//  SettingTabCell.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "SettingTabCell.h"
#import "SDPhotoBrowser.h"

@interface SettingTabCell()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIView *lineView;
@property (strong, nonatomic) NSArray *titleArr;

@end

@implementation SettingTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    
    return self;
}

#pragma mark - private methods
- (void)initUI
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.headImg];
    [self.contentView addSubview:self.addresslab];
    [self.contentView addSubview:self.lineView];
    
    //放大头像
    WEAKSELF;
    [_headImg whenTapped:^{
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.imageCount = 1; // 图片总数
        browser.currentImageIndex = 0;
        browser.delegate = self;
        browser.sourceImagesContainerView = weakSelf.headImg; // 原图的父控件
        [browser show];
    }];
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return kGetImage(@"icon_default_head");
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imgUrl = GET(_model.headPic);
    NSString *urlStr = [imgUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

- (void)settingUIwithRow:(NSInteger)row
{
    
    _nameLab.text = self.titleArr[row];

    if (row == 0) {
        _addresslab.hidden = YES;
        _headImg.hidden = NO;
        [_nameLab setFrame: CGRectMake(15, 30, 120, 20)];
        _lineView.frame = CGRectMake(15, 79.4, kMainScreenWidth-15, .6f);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        _addresslab.hidden = NO;
        _headImg.hidden = YES;
        [_nameLab setFrame: CGRectMake(15, 12, 120, 20)];
        _lineView.frame = CGRectMake(15, 43.4, kMainScreenWidth-15, .6f);
        
        if (row == 1) {
            if (_model.userName.length >0) {
                _addresslab.text = _model.userName;
            }
        }else if (row == 2){

            NSString *sexString = [NSString stringWithFormat:@"%@",_model.sex];
            if ([sexString isEqualToString:@"0"]) {
                _addresslab.text = @"男";
            }else if([sexString isEqualToString:@"1"]) {
                _addresslab.text = @"女";
            }else {
                _addresslab.text = @"保密";
            }

        }else if (row == 3){
            self.accessoryType = UITableViewCellAccessoryNone;
            if (_model.phone.length >=11) {
                _addresslab.text = [QZManager getTheHiddenMobile:_model.phone];
            }

        }else if (row == 4){
            if (_model.idNum.length >0) {
                _addresslab.text = _model.idNum;
            }
            
        }else if (row == 5){
            self.accessoryType = UITableViewCellAccessoryNone;
            NSString *typeString = [NSString stringWithFormat:@"%@",_model.userType];
            if ([typeString isEqualToString:@"1"]) {
                _addresslab.text = @"学校用户";
            }else {
                _addresslab.text = @"普通用户";
            }

        }else if (row == 6){
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            
            if (_model.province.length >0) {
                [areaString appendString:_model.province];
            }
            if (_model.city.length >0) {
                [areaString appendString:_model.city];
            }
            if (_model.area.length >0) {
                [areaString appendString:_model.area];
            }
            _addresslab.text = GET(areaString);
            
        }else if (row == 7){
            
            NSString *typeString = [NSString stringWithFormat:@"%@",_model.userType];
            if ([typeString isEqualToString:@"1"]) {
                
                if (_model.schoolName.length >0) {
                    _addresslab.text = _model.schoolName;
                }

            }else {
                if (_model.address.length >0) {
                    _addresslab.text = _model.address;
                    _nameLab.text = @"详细地址";

                }

            }

        }
        

    }
}

#pragma mark - setters and getters
- (void)setModel:(BasicData *)model
{
    _model = nil;
    _model = model;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"头像",@"姓名",@"性别",@"手机号码",@"身份证号",@"用户类别",@"所在地区",@"所在学校", nil];
    }
    return _titleArr;
}

- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = Font_15;
        _nameLab.textColor = THIRDCOLOR;
    }
    return _nameLab;
}
- (UILabel *)addresslab{
    if (!_addresslab) {
        _addresslab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -200, 12, 170, 20)];
        _addresslab.textColor = [UIColor colorWithHexString:@"#666666"];
        _addresslab.font = Font_12;
        _addresslab.textAlignment = NSTextAlignmentRight;
    }
    return _addresslab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90, 10, 60, 60)];
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
        _headImg.layer.cornerRadius = 30.f;
    }
    return _headImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
