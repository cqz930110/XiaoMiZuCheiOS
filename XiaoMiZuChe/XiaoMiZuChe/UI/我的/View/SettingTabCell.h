//
//  SettingTabCell.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicData.h"

@interface SettingTabCell : UITableViewCell

@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic) UILabel *addresslab;
@property (nonatomic, strong) UIImageView *headImg;
@property (strong, nonatomic) BasicData *model;

- (void)settingUIwithRow:(NSInteger)row;

@end
