//
//  MallViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "MallViewController.h"

@interface MallViewController ()


@property (nonatomic, strong) UIImageView *developImgView;
@end

@implementation MallViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"商城"];
    [self.view addSubview:self.developImgView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark - getters and setters
- (UIImageView *)developImgView
{
    if (!_developImgView) {
        _developImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 300)/2.f, (kMainScreenHeight - 409)/2.f, 300, 296)];
        _developImgView.image = kGetImage(@"pic_developing");
    }
    return _developImgView;
}
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
