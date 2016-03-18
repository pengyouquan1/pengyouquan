//
//  MBNewsWebViewController.m
//  pengyouquan
//
//  Created by 巫筠 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import "MBNewsWebViewController.h"
#import "UMSocial.h"
#import "UMSocialScreenShoter.h"

@interface MBNewsWebViewController ()

@end

@implementation MBNewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:230.0/255.0 green:77.0/255.0 blue:47.0/255.0 alpha:1.0];
    self.title = @"新闻";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    [moreButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [self createWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createWebView
{
    UIWebView * web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url = [[NSURL alloc]initWithString:self.newsUrl];
    [web  loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
}

-(void)more
{
    UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"你要分享的文字"
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.newsUrl;

    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
    
    
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56ea0aede0f55ae83e0004cb "shareText:@"分享文字" shareImage:image shareToSnsNames:nil delegate:nil];


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
