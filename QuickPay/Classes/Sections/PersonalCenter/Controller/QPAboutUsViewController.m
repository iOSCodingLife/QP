//
//  QPAboutUsViewController.m
//  QuickPay
//
//  Created by Nie on 2016/11/5.
//  Copyright © 2016年 Nie. All rights reserved.
//

#import "QPAboutUsViewController.h"

@interface QPAboutUsViewController ()<UIWebViewDelegate>

@end

@implementation QPAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleToNavBar:@"关于我们"];
    [self createBackBarItem];
    [self configureWebView];

}

#pragma mark - configureSubViews
-(void)configureWebView
{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [webView setScalesPageToFit:YES];
    NSString * url = [NSString stringWithFormat:@"%@/%@",QP_GetFixedQR,[QPUtils getMer_code]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{

    [[QPHUDManager sharedInstance]showProgressWithText:@"正在加载网页"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[QPHUDManager sharedInstance]hiddenHUD];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[QPHUDManager sharedInstance]hiddenHUD];
    [[QPHUDManager sharedInstance]showTextOnly:error.localizedDescription];
}

@end
