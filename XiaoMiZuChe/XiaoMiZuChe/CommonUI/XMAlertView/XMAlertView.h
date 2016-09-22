//
//  XMAlertView.h
//  XiaoMiZuChe
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XMAlertViewPro;
typedef enum {
    
    XMAlertViewStyleVerCode    = 0,//验证码
    
}XMAlertViewStyle;

@interface XMAlertView : UIView

@property (nonatomic, weak)   id<XMAlertViewPro>delegate;
@property (nonatomic, assign) XMAlertViewStyle style;

/**
 *  验证码
 *
 *  @param style style
 *
 *  @return return value description
 */
- (id)initWithVerificationCodeWithStyle:(XMAlertViewStyle)style;

@end
@protocol XMAlertViewPro <NSObject>

@optional
- (void)xMalertView:(XMAlertView *)alertView withClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
