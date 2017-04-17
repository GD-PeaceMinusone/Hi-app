//
//  ListObject.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/16.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>
#import "User.h"

typedef void (^MyCallback)(id obj);
@interface ListObject : NSObject
@property(nonatomic,strong)NSString *listTitle;
@property(nonatomic,strong)NSArray *textArr;
@property(nonatomic,strong)NSString *titlePagePath;
@property(nonatomic,strong)NSMutableArray *imagePaths;
@property(nonatomic,strong)BmobObject *bObj;
@property (nonatomic, strong)User *user;

-(void)saveWithCallback:(MyCallback)callback;
@end
