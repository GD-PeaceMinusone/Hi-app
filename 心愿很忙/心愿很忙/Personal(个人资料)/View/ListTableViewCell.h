//
//  ListTableViewCell.h
//  Hi
//
//  Created by Jackeylove on 2017/5/15.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
/** 接受传过来的模型 */
@property(nonatomic,strong)WishModel *avObj;
/** 内容文本 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 图片 */
@property (strong, nonatomic) IBOutlet UIImageView *thingIv;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;

@end
