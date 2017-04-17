//
//  User.h
//  ITSNS
//
//  Created by tarena on 16/5/16.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobUser.h>

@interface User : NSObject<NSCoding>
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, copy)NSString *like;
@property (nonatomic, strong)NSMutableArray *likeUsers;
@property (nonatomic, copy)NSNumber *scoreCount;
@property (nonatomic, copy)NSString *intro;
@property (nonatomic, copy)NSString *headUrlPath;

@property (nonatomic, strong)BmobUser *bUser;

-(instancetype)initWithBmobUser:(BmobUser *)bUser;


+(User *)currentUser;

-(void)update;

-(void)addScore:(int)score;

-(NSString *)createTime;

@end
