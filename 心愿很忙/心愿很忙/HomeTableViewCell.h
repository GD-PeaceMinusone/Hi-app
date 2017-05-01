//
//  HomeTableViewCell.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

/** 接受传过来的模型 */
@property(nonatomic,strong)AVObject *avObj;
/** 内容文本 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 图片 */
@property (strong, nonatomic) IBOutlet UIImageView *thingIv;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
/** 所有赞 */
@property (nonatomic, strong)NSArray *likes;

@end
