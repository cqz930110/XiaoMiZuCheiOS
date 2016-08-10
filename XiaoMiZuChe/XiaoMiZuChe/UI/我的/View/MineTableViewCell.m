//
//  MineTableViewCell.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.lineView];
}

- (void)settingCellStyle:(NSInteger)indexRow
{
    indexRow ==0?[_lineView setFrame:CGRectMake(0, 94.4, kMainScreenWidth, .6f)]:[_lineView setFrame:CGRectMake(0, 43.4f, kMainScreenWidth, 0.6f)];

    if (indexRow == 0) {
        
        _iconImgView.hidden  = YES;
        _titleLab.hidden = YES;
        
        _headImgView.hidden = NO;
        _phoneLab.hidden = NO;
        _registerTimeLab.hidden = NO;
        _lineView.hidden = NO;
        
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = _headImgView.frame.size.width/2.f;
        
        _phoneLab.text = [QZManager getTheHiddenMobile:[PublicFunction shareInstance].m_user.phone];
        _registerTimeLab.text = [NSString stringWithFormat:@"注册日期:%@",[PublicFunction shareInstance].m_user.regTime];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[PublicFunction shareInstance].m_user.headPic] placeholderImage:kGetImage(@"icon_default_head")];
        
    } else {
        _iconImgView.hidden  = NO;
        _titleLab.hidden = NO;
        
        _headImgView.hidden = YES;
        _phoneLab.hidden = YES;
        _registerTimeLab.hidden = YES;
        
        switch (indexRow) {
            case 1:
            {
                _iconImgView.image = kGetImage(@"icon_card");
                _titleLab.text = @"租车卡";
                _lineView.hidden = NO;
            }
                break;
            case 2:
            {
                _iconImgView.image = kGetImage(@"icon_service_terms");
                _titleLab.text = @"服务条款";
                _lineView.hidden = NO;

            }
                break;
            case 3:
            {
                _iconImgView.image = kGetImage(@"icon_minePhone");
                _titleLab.text = @"联系客服";
                _lineView.hidden = NO;

            }
                break;
            case 4:
            {
                _iconImgView.image = kGetImage(@"icon_about");
                _titleLab.text = @"关于";
                _lineView.hidden = YES;
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -setters and getters
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab  = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, 120, 20)];
        _titleLab.font = Font_15;
        _titleLab.textColor = thirdColor;
    }
    return _titleLab;
}
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lineColor;
    }
    return _lineView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
