//
//  User.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/27.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
/** 头像地址 */
@property(nonatomic,copy) NSString *headerPath;
/** 签名 */
@property(nonatomic,copy) NSString *sign;
/** 昵称 */
@property(nonatomic,copy) NSString *nickName;
/** 用户 */
@property (nonatomic, strong)BmobUser *bUser;

- (instancetype)initWithBmobUser:(BmobUser *)bUser;

-(void)update;

+(User *)getCurrentUser;
@end
