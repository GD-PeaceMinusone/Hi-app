//
//  HomeTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
-(UIImageView *)thingIv {

    if (!_thingIv) {
        
        _thingIv = [[UIImageView alloc]init];
        _thingIv.backgroundColor = XMGRandomColor;
        _thingIv.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_thingIv];
    }
    
    return _thingIv;
}
 */

-(void)setItObj:(ListObject *)itObj {
    
    _itObj = itObj;
    
    self.contentLabel.text = itObj.thingContent;
   
    NSURL *url = [NSURL URLWithString:itObj.thingPath];
    
    [self.thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
      
    }];
   
}

/**
 *  重写这个方法的目的: 能够拦截所有设置cell frame的操作
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= XMGMargin;
    frame.origin.y += XMGMargin;
    frame.size.width -= XMGMargin *2;
    frame.origin.x += XMGMargin;
    
    [super setFrame:frame];
}






@end
