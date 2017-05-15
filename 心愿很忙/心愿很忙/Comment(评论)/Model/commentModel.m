//
//  commentModel.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/4.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "commentModel.h"
#import "revertModel.h"

@implementation commentModel

-(commentModel *)initWithBmobObject:(BmobObject *)avObj {

    self = [super init];
    
    if (self) {
        
        _user = [avObj objectForKey:@"wishUser"];
        _content = [avObj objectForKey:@"content"];
        _comObj = avObj;
    }
    
    return self;
}

+(NSArray *)commentObjectArrayFromBmobObjArrary:(NSArray *)array {

    NSMutableArray *commentObjArr = [NSMutableArray array];
    
    for (BmobObject *obj in array) {
        
        commentModel *commentObj = [[commentModel alloc]initWithBmobObject:obj];
        
        [commentObjArr addObject:commentObj];
    }
    
    return commentObjArr;
}

-(NSInteger)cellHeight {

    CGFloat textMaxW = SCREEN_WIDTH - 70;
 
    CGSize textMaxSize = CGSizeMake(textMaxW - WSIMarginDouble, MAXFLOAT); //文本
    
    CGSize textSize = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;

    _cellHeight = textSize.height + WSIMarginDouble;
    
    _cellHeight += (20 + 20 + 10 * 4);
    
    return _cellHeight;
    

}

-(NSString *)commentTime {
    
    NSDate *createDate = _comObj.createdAt; // 获得状态发布的具体时间
    NSDate *nowDate = [NSDate date];  //获取当前时间对象
    long createTime = [createDate timeIntervalSince1970];
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-createTime;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日";
        return [fmt stringFromDate:createDate];
    }
}


@end
