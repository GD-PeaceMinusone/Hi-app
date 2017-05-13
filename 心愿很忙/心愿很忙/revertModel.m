//
//  revertModel.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/7.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "revertModel.h"

@implementation revertModel

-(revertModel *)initWithBmobObject:(BmobObject *)avObj {
    
    self = [super init];
    
    if (self) {
        
        _user = [avObj objectForKey:@"wishUser"];
        _content = [avObj objectForKey:@"content"];
       
    }
    
    return self;
}

+(NSArray *)revertObjectArrayFromBmobObjArrary:(NSArray *)array {
    
    NSMutableArray *commentObjArr = [NSMutableArray array];
    
    for (BmobObject *obj in array) {
        
        revertModel *commentObj = [[revertModel alloc]initWithBmobObject:obj];
        
        [commentObjArr addObject:commentObj];
    }
    
    return commentObjArr;
}

@end
