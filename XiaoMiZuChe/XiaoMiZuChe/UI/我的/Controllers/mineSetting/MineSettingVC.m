//
//  MineSettingVC.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "MineSettingVC.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "WHC_CameraVC.h"
#import "LCActionSheet.h"
#import "SettingTabCell.h"

static NSString *const SettingIdentifer    =  @"SettingIdentifer";

@interface MineSettingVC ()<UITableViewDataSource,UITableViewDelegate,WHC_ChoicePictureVCDelegate,WHC_CameraVCDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImage *headImage;

@end

@implementation MineSettingVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

#pragma mark - private methods

- (void)initUI{
    
    [self setupNaviBarWithTitle:@"基本资料"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];

    
    [self.view addSubview:self.tableView];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTabCell *cell = (SettingTabCell *)[tableView dequeueReusableCellWithIdentifier:SettingIdentifer];
    
    [cell settingUIwithRow:indexPath.row];
    if (_headImage)
    {
        cell.headImg.image = _headImage;
    }else{
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:@"http://image.anruan.com/img/1/13680_2.jpg"] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?80.f:44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        [self addActionSheet];
    }
}
- (void)addActionSheet
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        [self selectCameraOrPhotoList:buttonIndex];
    }];
    [sheet show];
}
#pragma mark -选择相机
- (void)selectCameraOrPhotoList:(NSUInteger)index
{
    switch (index)
    {
        case 0:
        {//从相机选择
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                SHOW_ALERT(@"亲，您的设备没有摄像头-_-!!");
            }else{
                WHC_CameraVC * vc = [WHC_CameraVC new];
                vc.delegate = self;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {//从相册选择一张
            WHC_PictureListVC  * vc = [WHC_PictureListVC new];
            vc.delegate = self;
            vc.maxChoiceImageNumberumber = 1;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    if (photoArr.count >0) {
        CGSize imgSize = CGSizeMake(80, 80);
        _headImage = [QZManager compressOriginalImage:photoArr[0] toSize:imgSize];
        
        /**
         *  上传图片
         */
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - WHC_CameraVCDelegate
- (void)WHCCameraVC:(WHC_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    
    [self WHCChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
}

#pragma mark - setters and getters

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight- 64.f) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[SettingTabCell class] forCellReuseIdentifier:SettingIdentifer];
    }
    return _tableView;
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
