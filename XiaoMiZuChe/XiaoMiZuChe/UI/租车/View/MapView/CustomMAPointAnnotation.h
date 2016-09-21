//
//  CustomMAPointAnnotation.h
//  GNETS 秘书
//
//  Created by FQ on 14-10-11.
//
//

#import <AMap3DMap/MAMapKit/MAAnnotation.h>
@interface CustomMAPointAnnotation :  NSObject <MAAnnotation>
/*!
 @brief 该类为一个抽象类，定义了基于MAAnnotation的MAShape类的基本属性和行为，不能直接使用，必须子类化之后才能使用
 */


/*!
 @brief 标题
 */
@property (nonatomic, copy) NSString *title;

/*!
 @brief 副标题
 */
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) NSUInteger tag;


@property  BOOL  selected;

/*!
 @brief 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end


