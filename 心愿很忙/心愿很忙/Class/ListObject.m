//
//  ListObject.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/16.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "ListObject.h"

@implementation ListObject

-(void)saveWithCallback:(MyCallback)callback {

    BmobObject *bObj = [BmobObject objectWithClassName:@"ListObject"];
    
    /**
     @property(nonatomic,strong)NSString *listTitle;
     @property(nonatomic,strong)NSMutableArray *textArr;
     @property(nonatomic,strong)NSString *titlePagePath;
     @property(nonatomic,strong)NSMutableArray *imagePaths;
     @property(nonatomic,strong)BmobObject *bObj;
     @property (nonatomic, strong)User *user;

     */
    
    [bObj setObject:self.listTitle forKey:@"listTitle"];
    [bObj setObject:self.textArr forKey:@"textArr"];
    [bObj setObject:self.titlePagePath forKey:@"titlePagePath"];
    [bObj setObject:self.imagePaths forKey:@"imagePaths"];
    
    BmobUser *user = [BmobUser currentUser];
    
    [bObj setObject:user forKey:@"user"];
    
    [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存出错：%@",error);
        }
    }];
}


@end
