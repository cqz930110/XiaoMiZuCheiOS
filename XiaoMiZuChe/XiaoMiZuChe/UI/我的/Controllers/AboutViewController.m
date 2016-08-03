//
//  AboutViewController.m
//  XiaoMiZuChe
//
//  Created by cqz on 16/8/3.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBarWithTitle:@"基本资料"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    
    _versionLab.text = [NSString stringWithFormat:@"For iOS %@",[self getVersion]];
}
-(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    return app_Version;
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
