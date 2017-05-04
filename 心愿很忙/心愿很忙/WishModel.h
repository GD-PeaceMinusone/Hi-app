//
//  WishModel.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/4.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WishModel : NSObject
/**配图文字*/
@property(nonatomic,copy) NSString *comment;
/**配图*/
@property(nonatomic,copy) NSString *picUrl;
/**宝贝链接*/
@property(nonatomic,copy) NSString *link;
/**头像*/
@property(nonatomic,copy) NSString *userHeader;
/**昵称*/
@property(nonatomic,copy) NSString *nickName;
/**发表时间*/
@property(nonatomic,copy) NSString *createdAt;
/**AVObject*/
@property(nonatomic,strong)AVObject *avObj;
/**AVUser*/
@property(nonatomic,strong)AVUser *user;
/**行高*/
@property (nonatomic,assign) NSInteger cellHeight;

-(WishModel*)initWithAvobject: (AVObject*)avObj;

+(NSArray*)wishObjectArrayFromAvobjectArrary: (NSArray*)array;
@end
