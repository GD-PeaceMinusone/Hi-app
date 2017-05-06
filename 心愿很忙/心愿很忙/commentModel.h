//
//  commentModel.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/4.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject
/**评论时间*/
@property(nonatomic,copy) NSString *commentTime;
/**评论内容*/
@property(nonatomic,copy) NSString *content;
/**评论人*/
@property(nonatomic,strong)BmobUser *user;
/**高度*/
@property (nonatomic,assign) NSInteger cellHeight;

-(commentModel*)initWithBmobObject: (BmobObject*)avObj;

+(NSArray*)commentObjectArrayFromBmobObjArrary: (NSArray*)array;
@end
