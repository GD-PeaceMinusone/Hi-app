//
//  PersonalTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/22.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import <SRActionSheet.h>

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //让cell 不响应点击事件
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 * 查看宝贝详情 和帮助实现愿望
 */
- (IBAction)giftButton:(id)sender {
    
    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"选择"
                                                cancelTitle:@"取消"
                                                destructiveTitle:nil
                                                otherTitles:@[@"查看详情", @"帮她/他实现心愿"]
                                                otherImages:nil
                                                selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                           }];
    
    [actionSheet show];
}


/**
 *  评论
 */
- (IBAction)commentButton:(id)sender {
}

/**
 *  赞
 */
- (IBAction)loveButton:(id)sender {
}

/**
 *  分享
 */
- (IBAction)shareButton:(id)sender {
}


/**
 *  重写这个方法的目的: 能够拦截所有设置cell frame的操作
 */
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= WSIMargin;
//    frame.origin.y += WSIMargin;
////    frame.size.width -= WSIMargin *2;
////    frame.origin.x += WSIMargin;
//    
//    [super setFrame:frame];
//}

@end
