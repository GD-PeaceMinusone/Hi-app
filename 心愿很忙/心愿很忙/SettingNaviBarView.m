//
//  SettingNaviBarView.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/26.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "SettingNaviBarView.h"

@implementation SettingNaviBarView


- (IBAction)backButton:(id)sender {
    
    [[UIViewController getNavi] popViewControllerAnimated:YES];
}


- (IBAction)wclButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
@end
