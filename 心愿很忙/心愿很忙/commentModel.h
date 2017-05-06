//
//  commentModel.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/4.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject
/**评论的昵称*/
@property(nonatomic,copy) NSString *commentName;
/**评论人头像*/
@property(nonatomic,copy) NSString *commentHead;
/**评论时间*/
@property(nonatomic,copy) NSString *commentTime;
/**评论内容*/
@property(nonatomic,copy) NSString *content;
@end
