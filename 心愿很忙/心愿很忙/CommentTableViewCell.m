//
//  CommentTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "BBInput.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *comHead;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *comContent;
@property (weak, nonatomic) IBOutlet UILabel *comTime;
@property (weak, nonatomic) IBOutlet UIView *revert1;
@property (weak, nonatomic) IBOutlet UIView *revert2;
@property (weak, nonatomic) IBOutlet UIView *revert3;
@property (weak, nonatomic) IBOutlet UIView *revert4;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_comHead circleHeader:_comHead withBorderWidth:0 andBorderColor:nil];
}


-(void)setComModel:(commentModel *)comModel {

    _comModel = comModel;
    
    [_comContent setText:comModel.content];
    
    [_comTime setText:[NSString stringWithFormat:@"%@", comModel.commentTime]];
    
    BmobQuery *q = [BmobQuery queryWithClassName:@"_User"];
    
    [q getObjectInBackgroundWithId:comModel.user.objectId block:^(BmobObject *object, NSError *error) {
        
        [_nickName setText:[object objectForKey:@"nickName"]];
        
        NSString *str = [object objectForKey:@"userHeader"];
        
        [_comHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    }];
}

- (IBAction)revert:(id)sender {
  
    [BBInput setDescTitle:@"回复"];
    [BBInput setMaxContentLength:140];
    [BBInput showInput:^(NSString *inputContent) {
        
        BmobObject *wishObj = [[BmobObject alloc] initWithClassName:@"Revert"]; //建表
        [wishObj setObject:inputContent forKey:@"content"]; //回复内容
        [wishObj setObject:_comModel.comObj forKey:@"comment"]; //回复的对应的评论
        [wishObj setObject:[BmobUser currentUser] forKey:@"wishUser"]; //回复人
        
        [wishObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                NSLog(@"回复成功");
                
                [self resignFirstResponder];
                
            }else {
                
                NSLog(@"评论失败");
            }
            
        }];
        
       
    }];
    
}



@end
