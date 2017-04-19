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
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *thingContent;
@property(nonatomic,strong)NSString *thingPath;
@property(nonatomic,strong)BmobObject *bObj;
@property (nonatomic, strong)BmobUser *user;

-(ListObject *)initWithBmobObject:(BmobObject *)bObj;
-(void)saveWithCallback:(MyCallback)callback;
+(NSArray *)ListObjcetArrayFromBmobObjectArray:(NSArray *)array;
@end
