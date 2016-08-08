//
//  PerfectInformationVC.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/3.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "PerfectInformationVC.h"
#import "MyPickView.h"

@interface PerfectInformationVC ()

@end

@implementation PerfectInformationVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"完善资料"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    self.view.backgroundColor = [UIColor whiteColor];

    
}
#pragma mark - event response

#pragma mark -
#pragma mark - setters and getters


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
