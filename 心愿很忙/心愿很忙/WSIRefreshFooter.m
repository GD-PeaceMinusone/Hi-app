//
//  XMGRefreshFooter.m
//  百思不得姐
//
//  Created by Jackeylove on 2017/3/17.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRefreshFooter.h"

@implementation WSIRefreshFooter

- (void)prepare {

    [super prepare];
    //刷新控件出现一半 就开始刷新操作
    self.triggerAutomaticallyRefreshPercent = 0.5;
}

@end
