//
//  ListObject.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/16.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>

typedef void (^MyCallback)(id obj);
@interface ListObject : NSObject
/**宝贝链接地址*/
@property(nonatomic,strong)NSString *link;
/**文本内容*/
@property(nonatomic,strong)NSString *thingContent;
/**内容图片地址*/
@property(nonatomic,strong)NSString *thingPath;
/**BmobObject 对象*/
@property(nonatomic,strong)BmobObject *bObj;
/**BmobUser 对象*/
@property (nonatomic, strong)BmobUser *user;
/**cell高度*/
@property (nonatomic,assign) CGFloat cellHeight;
/** 图片的真实宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的真实高度 */
@property (nonatomic, assign) CGFloat height;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;

-(ListObject *)initWithBmobObject:(BmobObject *)bObj;
-(void)saveWithCallback:(MyCallback)callback;
+(NSArray *)ListObjcetArrayFromBmobObjectArray:(NSArray *)array;

@end
