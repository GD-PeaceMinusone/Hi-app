//
//  CommentTableViewCell.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property(nonatomic,strong)commentModel *comModel;
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;

@end
