//
//  ListObject.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/16.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "ListObject.h"
#import "HUDUtils.h"

@implementation ListObject

-(void)saveWithCallback:(MyCallback)callback {

    BmobObject *bObj = [BmobObject objectWithClassName:@"ListObject"];

    [bObj setObject:self.link forKey:@"link"];
    [bObj setObject:self.thingPath forKey:@"thingPath"];
    [bObj setObject:self.thingContent forKey:@"thingContent"];
    
   
    
    [bObj setObject:self.user forKey:@"user"];

    [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            NSLog(@"保存成功---%@",error);
            [HUDUtils setupSuccessWithStatus:@"清单已生成" WithDelay:2.0f completion:^{
            
                [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }else{
            NSLog(@"保存出错---%@",error);
        }
    }];
}

-(ListObject *)initWithBmobObject:(BmobObject *)bObj {

    self = [super init];
    
    if (self) {
        
        self.link = [bObj objectForKey:@"link"];
        self.thingPath = [bObj objectForKey:@"thingPath"];
        self.thingContent = [bObj objectForKey:@"thingContent"];
        self.user =[bObj objectForKey:@"user"];
        
    }
    
    return self;
    
}



+(NSArray *)ListObjcetArrayFromBmobObjectArray:(NSArray *)array {


    NSMutableArray *itObjArray = [NSMutableArray array];
    for (BmobObject *bObj in array) {
        ListObject *itObj = [[ListObject alloc]initWithBmobObject:bObj];
        
        [itObjArray addObject:itObj];
    }
    return itObjArray;
}


@end
