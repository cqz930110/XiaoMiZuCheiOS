//
//  NavMapWindow.h
//  ZhouDao
//
//  Created by cqz on 16/3/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^ZDStringBlock)(NSString *);
//typedef void(^ZDBlock)();

@interface NavMapWindow : UIWindow

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, copy) ZDStringBlock navBlock;
//@property (nonatomic, copy) ZDBlock exitBlock;

-(void)zd_Windowclose;

@end
