//
//  revertModel.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/7.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface revertModel : NSObject
/**回复时间*/
@property(nonatomic,copy) NSString *commentTime;
/**回复内容*/
@property(nonatomic,copy) NSString *content;
/**回复人*/
@property(nonatomic,strong)BmobUser *user;
/**高度*/
@property (nonatomic,assign) NSInteger cellHeight;

-(revertModel*)initWithBmobObject: (BmobObject*)avObj;

+(NSArray*)revertObjectArrayFromBmobObjArrary: (NSArray*)array;
@end
