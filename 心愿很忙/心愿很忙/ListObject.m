//
//  ListObject.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/16.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "ListObject.h"
#import "HUDUtils.h"

@implementation ListObject

/**
 *  异步保存数据
 */

-(void)saveWithCallback:(MyCallback)callback {
    
    BmobObject *bObj = [BmobObject objectWithClassName:@"ListObject"];
    
    [bObj setObject:self.link forKey:@"link"];
    [bObj setObject:self.thingPath forKey:@"thingPath"];
    [bObj setObject:self.thingContent forKey:@"thingContent"];
//    [bObj setObject:self.width forKey:@"width"];
//    [bObj setObject:self.height forKey:@"height"];
    
    [bObj setObject:self.user forKey:@"user"];
    
    [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            NSLog(@"保存成功---%@",error);
            [HUDUtils setupSuccessWithStatus:@"清单已生成" WithDelay:2.0f completion:^{
                
                [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }else{
            NSLog(@"保存出错---%@",error);
            [HUDUtils setupErrorWithStatus:@"清单未生成" WithDelay:2.0f completion:nil];
        }
    }];
}


/**
 *  初始化时将Bmobject对象转化成Lis他Object对象
 */
-(ListObject *)initWithBmobObject:(BmobObject *)bObj {
    
    self = [super init];
    
    if (self) {
        
        self.link = [bObj objectForKey:@"link"];
        self.thingPath = [bObj objectForKey:@"thingPath"];
        self.thingContent = [bObj objectForKey:@"thingContent"];
        self.user =[bObj objectForKey:@"user"];
        
    }
    
    return self;
    
}


/**
 *  将数组里的BmobObject 转换成ListObject对象
 */
+(NSArray *)ListObjcetArrayFromBmobObjectArray:(NSArray *)array {
    
    
    NSMutableArray *itObjArray = [NSMutableArray array];
    for (BmobObject *bObj in array) {
        ListObject *itObj = [[ListObject alloc]initWithBmobObject:bObj];
        
        [itObjArray addObject:itObj];
    }
    return itObjArray;
}


/**
 *  动态设置cell的高度
 */

- (CGFloat)cellHeight {
    
    // 如果cell的高度已经计算过, 就直接返回
    if (_cellHeight) return _cellHeight;
    
    //头像
    _cellHeight = (49 + 12 + 16 + 0.33);
    
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - WSIMarginDouble;
    
    if (_thingPath) {
        
//        //图片
//        CGFloat contentH = textMaxW * [_height floatValue] / [_width floatValue];
//        _cellHeight += contentH + WSIMarginDouble;
        _cellHeight += 250;
    }
    
    
    //文本
    CGSize textMaxSize = CGSizeMake(textMaxW - WSIMarginDouble, MAXFLOAT);
    
    CGSize textSize = [self.thingContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    _cellHeight += (textSize.height + WSIMarginDouble);
    
    //图标
    _cellHeight += 57;
    
    return _cellHeight;
}



@end
