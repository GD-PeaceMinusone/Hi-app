
//
//  WishModel.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/4.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WishModel.h"

@implementation WishModel

-(WishModel*)initWithBmobObject: (BmobObject*)avObj {
    
    self = [super init];
    
    if (self) {
        
        _user = [avObj objectForKey:@"wishUser"];
        _objectId = _user.objectId;
        _comment = [avObj objectForKey:@"content"];
        _picUrl = [avObj objectForKey:@"picUrl"];
        _link = [avObj objectForKey:@"link"];
        _avObj = avObj;
    }
    
    return self;
}



+(NSArray<WishModel*> *)wishObjectArrayFromAvobjectArrary:(NSArray *)array {
    
    NSMutableArray *wishObjArr = [NSMutableArray array];
    
    for (BmobObject *obj in array) {
        
        WishModel *wishObj = [[WishModel alloc]initWithBmobObject:obj];
        
        [wishObjArr addObject:wishObj];
    }
    
    return wishObjArr;
}


-(NSString *)createdAt {
    
    NSDate *createDate = _avObj.createdAt; // 获得状态发布的具体时间
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
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

-(NSInteger)cellHeight {
    
    _cellHeight = (49 + 12 + 16 + 0.33); //头像
    
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - WSIMarginDouble;
    
    if (_picUrl) {
        
        _cellHeight += 300;
    }
    
    CGSize textMaxSize = CGSizeMake(textMaxW - WSIMarginDouble, MAXFLOAT); //文本
    
    CGSize textSize = [_comment boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    _cellHeight += (textSize.height + WSIMarginDouble);
    
    _cellHeight += 90; //图标
    
    return _cellHeight;
}

-(NSInteger)comCellHeight {

    _cellHeight = (49 + 12 + 16 + 0.33); //头像
    
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - WSIMarginDouble;
    
    if (_picUrl) {
        
        _cellHeight += 300;
    }
    
    CGSize textMaxSize = CGSizeMake(textMaxW - WSIMarginDouble, MAXFLOAT); //文本
    
    CGSize textSize = [_comment boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    _cellHeight += (textSize.height + WSIMarginDouble);
    
    _cellHeight += 20; //图标
    
    return _cellHeight;
    
}

@end
