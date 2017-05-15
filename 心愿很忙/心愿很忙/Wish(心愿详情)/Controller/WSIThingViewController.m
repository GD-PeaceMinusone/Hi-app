//
//  ViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/24.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIThingViewController.h"
#import <WebKit/WebKit.h>

@interface WSIThingViewController ()

@end

@implementation WSIThingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWeb:) name:@"link" object:nil];
    NSLog(@"222");
}

-(void)loadWeb:(NSNotification *)noti {
    NSLog(@"eeeee");
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
  
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:noti.object]];
    [webView loadRequest:request];
}



@end
