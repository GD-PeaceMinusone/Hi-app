//
//  User.m
//  ITSNS
//
//  Created by tarena on 16/5/16.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "User.h"
#import <BmobSDK/BmobObject.h>
static User *_user;
@implementation User

+(User *)getCurrentUser{
    if (!_user) {
        _user = [[User alloc]initWithBmobUser:[BmobUser currentUser]];
    }
    
    return _user;
}


- (instancetype)initWithBmobUser:(BmobUser *)bUser
{
    self = [super init];
    if (self) {
        self.nick = [bUser objectForKey:@"nick"];
        self.intro = [bUser objectForKey:@"intro"];
        self.like = [bUser objectForKey:@"like"];
        self.scoreCount = [bUser objectForKey:@"scoreCount"];
        self.headUrlPath = [bUser objectForKey:@"headUrlPath"];
        self.bUser = bUser;
    }
    return self;
}



-(void)update{
    
   
    
    
    [self.bUser setObject:self.nick forKey:@"nick"];
    [self.bUser setObject:self.scoreCount forKey:@"scoreCount"];
    [self.bUser setObject:self.headUrlPath forKey:@"headUrlPath"];
    [self.bUser setObject:self.like forKey:@"like"];
    [self.bUser setObject:self.intro forKey:@"intro"];
    
    [self.bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新个人信息成功！");
        }else{
            NSLog(@"更新失败：%@",error);
        }
    }];
    
    
}


-(void)addScore:(int)score{
    
    [self.bUser incrementKey:@"scoreCount"  byAmount:score];
    
    
    //更新数据的时候 原来的对象类型的字段需要重新赋值 不然会报错！

    [self.bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            self.scoreCount = @(self.scoreCount.intValue + score);
            NSLog(@"增加积分成功！");
        }else{
            NSLog(@"增加出错：%@",error);
        }
    }];
    
}

-(NSString *)createTime{
    
    
    
    
    
    // 获得具体时间
    NSDate *createDate = self.bUser.createdAt;
    //获取当前时间对象
    NSDate *nowDate = [NSDate date];
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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.nick forKey:@"nick"];
    [aCoder encodeObject:self.headUrlPath forKey:@"headUrlPath"];
    
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.nick=[aDecoder decodeObjectForKey:@"nick"];
        self.headUrlPath=[aDecoder decodeObjectForKey:@"headUrlPath"];
    }
    return self;
}

@end
