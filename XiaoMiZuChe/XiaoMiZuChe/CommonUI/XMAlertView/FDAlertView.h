//
//  FDAlertView.h
//  GNETS
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol FDAlertViewDelegate;

@interface FDAlertView : UIView

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, copy) ZCBlock navBlock;
//@property (nonatomic, weak) id<FDAlertViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withTit:(NSString *)tit withMsg:(NSString *)msg;

-(void)zd_Windowclose;

@end


//@protocol FDAlertViewDelegate <NSObject>
//
//@optional
//
//- (void)alertViewClickedButtonEvent;
//@end
