//
//  SelectTimeAlert.h
//  GNETS
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@protocol SelectTimeAlertPro;

@interface SelectTimeAlert : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id<SelectTimeAlertPro>delegate;
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *backgroundView;

- (id)initWithFrame:(CGRect)frame;

- (void)show;

@end

@protocol SelectTimeAlertPro <NSObject>
- (void)ShowTheRoadWithKSDate:(NSMutableArray *)locArrays WithStar:(CLLocationCoordinate2D)qidian withEnd:(CLLocationCoordinate2D)endcll;
//- (void)newAlertView:(SelectTimeAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end