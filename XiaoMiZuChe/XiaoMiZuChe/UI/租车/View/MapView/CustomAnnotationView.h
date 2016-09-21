//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//
#import <MAMapKit/MAAnnotationView.h>
#import <MAMapKit/MAAnnotation.h>
typedef void(^Annotationblock)();


@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) Annotationblock annBlock;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger tagz;

@property (nonatomic, copy) NSString *calloutText;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@end
