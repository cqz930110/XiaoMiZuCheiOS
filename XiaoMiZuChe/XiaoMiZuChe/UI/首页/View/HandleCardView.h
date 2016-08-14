//
//  HandleCardView.h
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/13.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HandleCardViewPro;
@interface HandleCardView : UIView

@property (nonatomic, weak) id<HandleCardViewPro>delegate;

- (id)initWithFrame:(CGRect)frame WithMoney:(NSString *)money;

@end
@protocol HandleCardViewPro <NSObject>

- (void)choiceOfPaymentWithIndex:(NSInteger)index;

@end