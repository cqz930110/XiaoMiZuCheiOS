//
//  SettingTabCell.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTabCell : UITableViewCell

@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic) UILabel *addresslab;
@property (nonatomic, strong) UIImageView *headImg;

- (void)settingUIwithRow:(NSInteger)row;

@end
