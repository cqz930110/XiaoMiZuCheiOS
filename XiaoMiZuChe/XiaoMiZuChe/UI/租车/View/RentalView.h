//
//  RentalView.h
//  XiaoMiZuChe
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  RentalViewDelegate;

@interface RentalView : UIView


@property (weak, nonatomic)   id<RentalViewDelegate>delegate;

- (id)initUIWithDelegate:(id<RentalViewDelegate>)delegate withViewController:(UIViewController *)superViewController;
@end

@protocol  RentalViewDelegate <NSObject>

- (void)rentalCarSUccess;
@end
