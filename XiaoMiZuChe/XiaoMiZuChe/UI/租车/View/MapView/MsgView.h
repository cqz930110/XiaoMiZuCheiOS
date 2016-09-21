//
//  MsgView.h
//  GNETS
//
//  Created by cqz on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocInfodata.h"

@interface MsgView : UIView
@property (nonatomic,strong) LocInfodata *model;

- (id)initWithFrame:(CGRect)frame With:(LocInfodata *)model WithLocalCoordinate:(CLLocationCoordinate2D)coordinate2D;
@end
