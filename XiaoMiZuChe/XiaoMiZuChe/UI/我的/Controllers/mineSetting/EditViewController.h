//
//  EditViewController.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditViewController : BaseViewController


@property (nonatomic, copy) ZCStringBlock editBlock;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;

@end
