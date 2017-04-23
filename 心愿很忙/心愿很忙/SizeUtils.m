//
//  SizeUtils.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/23.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "SizeUtils.h"

@implementation SizeUtils

/**
 *  计算用户输入文本的size
 */

+(CGSize)stringSizeWithString:(NSString *)string {

    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - WSIMarginDouble;
    //文本
    CGSize textMaxSize = CGSizeMake(textMaxW - WSIMarginDouble, MAXFLOAT);
    
    CGSize textSize = [string boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    return textSize;
}

@end
