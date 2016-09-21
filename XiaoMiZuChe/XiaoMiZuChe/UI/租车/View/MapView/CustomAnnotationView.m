//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "UIView+WhenTappedBlocks.h"
#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   150.0
#define kCalloutHeight  77.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;
@synthesize calloutText = _calloutText;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self.calloutView removeFromSuperview];
    if (self.selected == selected)
    {
        UIWindow *windows = [UIApplication sharedApplication].windows[0];
        UIView *maskView = (UIView *)[windows viewWithTag:3000];

        if (maskView) {
            if (_annBlock) {
                _annBlock();
            }
            return;
        }
        //return;
    }else{
        if (selected)
        {
            if (self.calloutView == nil)
            {
                /* Construct custom callout. */
                UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,110,65)];
                UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,110,65)];
                [bgImgView setImage:[UIImage imageNamed:@"callout.png"]];
                bgImgView.userInteractionEnabled = YES;
                
                [myView addSubview:bgImgView];
                
                self.calloutView = myView;
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                      -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 100, 60)];
                name.textColor = [UIColor blackColor];
                name.font=[UIFont boldSystemFontOfSize:10];
                name.lineBreakMode = NSLineBreakByWordWrapping;
                
                name.numberOfLines = 0;
                
                if (_calloutText.length >0){
                    name.text = self.calloutText;
                    
                    
                }else{
                    name.text = @"点击选择设为起点";
                    name.textAlignment = NSTextAlignmentCenter;
                    _tagz =2002;
                    self.calloutView.tag = 3000;
                    //self.pointBlock(_tagz);
                }
                
                [self.calloutView addSubview:name];
            }
            
            [self addSubview:self.calloutView];
            
        }
        else
        {
            [self.calloutView removeFromSuperview];
        }
        
    }
   
    [super setSelected:selected animated:animated];
}
//- (void)tapEvents{
//    
//    if ([self.delegate respondsToSelector:@selector(tapClickWith:WithTag:)]) {
//        [self.delegate tapClickWith:self WithTag:2002];
//    }
//    
//}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
//        self.backgroundColor = [UIColor grayColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        [self addSubview:self.portraitImageView];
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
                                                                   kVertMargin,
                                                                   kWidth - kPortraitWidth - kHoriMargin,
                                                                   kHeight - 2 * kVertMargin)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end
