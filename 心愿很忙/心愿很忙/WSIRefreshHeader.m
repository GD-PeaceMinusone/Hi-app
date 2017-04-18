//
//  XMGRefreshHeader.m
//  百思不得姐
//
//  Created by Jackeylove on 2017/3/17.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRefreshHeader.h"

@interface WSIRefreshHeader ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation WSIRefreshHeader
-(void)prepare {

    [super prepare];
    self.automaticallyChangeAlpha = YES;
}

////初始化
//- (void)prepare {
//
//    [super prepare];
//    
////    self.automaticallyChangeAlpha = YES;
////    self.lastUpdatedTimeLabel.textColor = [UIColor redColor];
////    self.stateLabel.textColor = [UIColor blueColor];
////    [self setTitle:@"赶紧下拉吧" forState:MJRefreshStateIdle];
////    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
////    [self setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
////    
////    UIImageView *imageView = [[UIImageView alloc]init];
////    self.imageView = imageView;
////    imageView.image = [UIImage imageNamed:@"logo_white_fe6da1ec"];
////    [self addSubview:imageView];
//    
//}
//
////设置子控件的位置大小
//- (void)placeSubviews {
//
////    [super placeSubviews];
////    self.imageView.xmg_width = self.xmg_width;
////    self.imageView.xmg_height = 60;
////    self.imageView.xmg_x = 0;
////    self.imageView.xmg_y = -60;
//}
@end
