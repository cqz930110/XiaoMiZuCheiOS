//
//  SelectTimeCell.m
//  GNETS
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectTimeCell.h"

@implementation SelectTimeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
