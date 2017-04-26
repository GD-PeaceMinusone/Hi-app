//
//  BBInput.h
//  SoloVideo
//
//  Created by 项羽 on 16/9/22.
//  Copyright © 2016年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(NSString *inputContent);

@interface BBInput : NSObject

/**
 *  点击确定按钮回调
 */
+(void)showInput:(ConfirmBlock)confirmHandler;

/**
 *  设置默认文字
 */
+(void)setNormalContent:(NSString *)content;

/**
 *  输入文字的最大长度
 */
+(void)setMaxContentLength:(NSInteger)lenght;

/**
 *  设置标题
 */
+(void)setDescTitle:(NSString *)descTitle;

@end
