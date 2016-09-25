//
//  ServiceViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "ServiceViewController.h"
#import "UIWebView+Load.h"

@interface ServiceViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer* _singleTap;//失败重新加载
}
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ServiceViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"服务条款"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"icon_left_arrow"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self loadServiceURLString];
}
- (void)loadServiceURLString{
    
    [_webView loadURL:@"http://api.xiaomiddc.com/app/h5/service_terms.html"];
    if (_singleTap) {
        [_webView removeGestureRecognizer:_singleTap];
    }

}
#pragma mark - UIWebViewDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMBLoadingWithText:nil];
    DLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUD];
    DLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
    
    [_webView loadHtml:@"error"];
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againLoad)];
    _singleTap.cancelsTouchesInView = NO;
    _singleTap.delegate = self;
    [_webView addGestureRecognizer:_singleTap];
    DLog(@"加载失败");
}
- (void)againLoad{
    DLog(@"重新加载");
    [self loadServiceURLString];
}

#pragma mark - setters and getters
- (UIWebView *)webView
{
    if (!_webView) {
        _webView.backgroundColor = [UIColor clearColor];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;//禁止用户缩放页面
        _webView.delegate = self;
        [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
    }
    return _webView;
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
