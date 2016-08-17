//
//  MineSettingVC.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "MineSettingVC.h"
#import "LCActionSheet.h"
#import "SettingTabCell.h"
#import "EditViewController.h"
#import "MyPickView.h"
#import "BasicData.h"
#import "ZHPickView.h"

static NSString *const SettingIdentifer    =  @"SettingIdentifer";

@interface MineSettingVC ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImage *headImage;
@property (strong, nonatomic) BasicData *dataModel;
@property (strong, nonatomic) NSMutableDictionary *schoolDict;

@end

@implementation MineSettingVC

#pragma mark - life cycle

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [PublicFunction shareInstance].m_user = _dataModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self loadBasicData];
}
#pragma mark - private methods

- (void)loadBasicData
{WEAKSELF;
    NSString *userIdString = [NSString stringWithFormat:@"%@",[PublicFunction shareInstance].m_user.userId];
    [APIRequest getUserInfoWithUserId:userIdString RequestSuccess:^(id obj) {
        
        weakSelf.dataModel = (BasicData *)obj;
        if ([weakSelf.dataModel.userType integerValue] == 1) {
            [weakSelf loadSchoolData];
        }
        [weakSelf.tableView reloadData];
    } fail:^{
        FDAlertView *alert = [[FDAlertView alloc] initWithFrame:kMainScreenFrameRect withTit:@"温馨提示" withMsg:@"加载个人信息失败"];
        alert.navBlock = ^(){
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }];
}
- (void)loadSchoolData{WEAKSELF;
    
    [APIRequest getSchoolsWithProvince:_dataModel.province withCity:_dataModel.city witharea:_dataModel.area RequestSuccess:^(NSMutableDictionary *dict) {
        
        weakSelf.schoolDict = dict;
    } fail:^{
    }];
}
- (void)postUserDataWithDict:(NSDictionary *)dict withContent:(NSString *)conString WithProvince:(NSString *)province WithCity:(NSString *)city Witharea:(NSString *)area WithRow:(NSInteger)row
{WEAKSELF;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,UPDATEUSERDATAURL];

    [APIRequest updateUserDataWithPostDict:dict withURLString:urlString RequestSuccess:^{
        
        if (row == 7) {
            weakSelf.dataModel.schoolName = conString;
        }else if (row == 2){
            if ([conString isEqualToString:@"男"]) {
                weakSelf.dataModel.sex = @0;
            }else if ([conString isEqualToString:@"女"]){
                weakSelf.dataModel.sex = @1;
            }else{
                weakSelf.dataModel.sex = @2;
            }
        }else {
            weakSelf.dataModel.province = province;
            weakSelf.dataModel.city = city;
            weakSelf.dataModel.area = area;
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    } fail:^{
    }];

}
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
    
    if (_dataModel) {
        cell.model = _dataModel;
    }
    [cell settingUIwithRow:indexPath.row];
    if (_headImage)
    {
        cell.headImg.image = _headImage;
    }else{
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:_dataModel.headPic] placeholderImage:kGetImage(@"icon_default_head")];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?80.f:44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        [self addActionSheet];
    }else if (row == 2){
        [self modifyTheGender];
    }else if (row == 6){
        [self selectProvinceCityArea];
        
    }else if (row == 7){
        
        [self editUserTypeData];
    }else if (row == 1 || row == 4){
        [self editUserInformationWithRow:row];
    }
}
- (void)editUserTypeData
{WEAKSELF;
    if ([_dataModel.userType  integerValue] == 2) {
        
        EditViewController *vc = [EditViewController new];
        vc.titleStr = @"详细地址";
        if (_dataModel.address.length >0) {
            vc.contentStr = _dataModel.address;
        }
        vc.editBlock = ^(NSString *modifyString){
            
            weakSelf.dataModel.address = modifyString;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (self.schoolDict) {
            [self selectSchoolEvent];
        }
    }
}
- (void)selectSchoolEvent{WEAKSELF;
    NSArray *arrays = [_schoolDict allKeys];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:arrays title:@"选择学校"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *schoolString)
    {
        NSString *schoolId = _schoolDict[schoolString];

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",GET(schoolId),@"schoolId", nil];
        [weakSelf postUserDataWithDict:dict withContent:schoolString WithProvince:nil WithCity:nil Witharea:nil WithRow:7];
    };
}
- (void)editUserInformationWithRow:(NSInteger)row
{WEAKSELF;
    EditViewController *vc = [EditViewController new];
    if (row == 1) {
        vc.titleStr = @"姓名";
        if (_dataModel.userName.length >0) {
            vc.contentStr = _dataModel.userName;
        }
        vc.editBlock = ^(NSString *modifyString){
            
            weakSelf.dataModel.userName = modifyString;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if (row == 4){
        vc.titleStr = @"身份证号";
        if (_dataModel.idNum.length >0) {
            vc.contentStr = _dataModel.idNum;
        }
        vc.editBlock = ^(NSString *modifyString){
            
            weakSelf.dataModel.idNum = modifyString;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)modifyTheGender{WEAKSELF;
    NSInteger index = 0;
    NSString *sexString = [NSString stringWithFormat:@"%@",_dataModel.sex];
    if ([sexString isEqualToString:@"1"]) {
        index = 1;
    }else if([sexString isEqualToString:@"2"]) {
        index = 2;
    }
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择性别" buttonTitles:@[@"男",@"女",@"保密"] redButtonIndex:index clicked:^(NSInteger buttonIndex) {
        
        NSString *sexString = @"";
        if (buttonIndex == 0) {
            sexString = @"男";
        }else if(buttonIndex == 1) {
            sexString = @"女";
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",[NSString stringWithFormat:@"%ld",(long)buttonIndex],@"sex", nil];
        [weakSelf postUserDataWithDict:dict withContent:sexString WithProvince:nil WithCity:nil Witharea:nil WithRow:2];
    }];
    [sheet show];
}
- (void)selectProvinceCityArea{WEAKSELF;
    UIWindow *windows = [QZManager getWindow];
    MyPickView *pickView = [[MyPickView  alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    pickView.pickBlock = ^(NSString *provice,NSString *city,NSString *area){
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PublicFunction shareInstance].m_user.userId,@"userId",provice,@"province",city,@"city",area,@"area", nil];
        [weakSelf postUserDataWithDict:dict withContent:nil WithProvince:provice WithCity:city Witharea:area WithRow:6];
    };
    [windows addSubview:pickView];
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

                kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                    
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.delegate = self;
                    imagePickerController.showsCameraControls = YES;//是否显示照相机标准的控件库
                    [imagePickerController setAllowsEditing:YES];//是否加入照相后预览时的编辑功能

                    kDISPATCH_MAIN_THREAD(^{
                        
                        [self presentViewController:imagePickerController animated:YES completion:nil];
                    });
                });
            }
        }
            break;
        case 1:
        {
            
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;
                kDISPATCH_MAIN_THREAD(^{
                    
                    [self presentViewController:picker animated:YES completion:nil];
                });
            });
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    // UIImagePickerControllerOriginalImage
    UIImage  * image = info[@"UIImagePickerControllerEditedImage"];
    _headImage = image;
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    });

    [self uploadHeaderImageItemClick];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [navigationController.viewControllers count] <=2) {
        navigationController.navigationBar.translucent = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        navigationController.navigationBarHidden = NO;
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else {
        navigationController.navigationBarHidden = YES;
    }
}

- (void)uploadHeaderImageItemClick
{
    WEAKSELF;
    if (_headImage >0) {
//        CGSize imgSize = CGSizeMake(80, 80);
//        _headImage = [QZManager compressOriginalImage:_headImage toSize:imgSize];
        
        NSData *fileData = [QZManager compressOriginalImage:_headImage toMaxDataSizeKBytes:100.f];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:fileData,@"headPic", nil];
        
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [APIRequest updateHeadPicWithParaDict:dictionary RequestSuccess:^(NSString *headUrlString) {
                
                kDISPATCH_MAIN_THREAD((^{
                    
                    weakSelf.dataModel.headPic = headUrlString;
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }));
            } fail:^{
                _headImage = nil;
            }];
        });
    }

}

#pragma mark - setters and getters

- (NSMutableDictionary *)schoolDict
{
    if (!_schoolDict) {
        _schoolDict = [NSMutableDictionary dictionary];
    }
    return _schoolDict;
}
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
