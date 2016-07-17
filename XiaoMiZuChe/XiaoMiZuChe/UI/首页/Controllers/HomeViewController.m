//
//  HomeViewController.m
//  XiaoMiZuChe
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "HomeViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface HomeViewController ()

@property (nonatomic, assign) int clientSocket;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNaviBarWithTitle:@"首页"];
    
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    

    if (![self connectToHost]) {
        NSLog(@"失败");
        return;
    }
    NSLog(@"成功");
    
    
    
    NSString *msg = @"ooo";
    ssize_t sendLen = send(self.clientSocket, msg.UTF8String, strlen(msg.UTF8String), 0);
    
    
    uint8_t buffer[1024];
    ssize_t recelen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    NSString *result = [[NSString alloc] initWithBytes:buffer length:recelen encoding:NSUTF8StringEncoding];
}
- (int)connectToHost
{
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serverAddr.sin_port = htons(123456);
    
    return connect(self.clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr)) == 0;
}
#pragma mark -断开连接
- (void)disconnect {
    
    close(self.clientSocket)
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
