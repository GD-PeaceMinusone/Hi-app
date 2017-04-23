//
//  PersonalTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/22.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import <SRActionSheet.h>
#import <UShareUI/UShareUI.h>

@interface PersonalTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contetnIv;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

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
    
    [self shareWithUI];
    
}


/**
 *  处理分享照片模板
 */

- (UIImage *)imageAddText:(UIImage *)image withName:(NSString *)name andHeader: (UIImage *)headerImg
{
    
    CGSize textSize = [SizeUtils stringSizeWithString:name];
    
    UIImage *headerImage = [UIImage imageWithIconName:@"header" borderImage:nil border:0];
    
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h + 1000));
    
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    [headerImage drawInRect:CGRectMake(w - 850 - textSize.width - 310, h + 640, 250, 250)];
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:100], NSForegroundColorAttributeName : [UIColor blackColor]  };
    //位置显示
    [name drawInRect:CGRectMake(w - 850 - textSize.width,h + 700, w*0.5, h*0.3) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}

- (void)shareWithUI {

    UIImage *headerImg  = [UIImage imageNamed:@"header"];
    
    UIImage *image = [self imageAddText:_contetnIv.image withName:@"我想想还是不结婚了" andHeader:headerImg];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
  
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        
        switch (platformType) {
            case UMSocialPlatformType_QQ:
            
            {
                [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106117908"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                messageObject.text = _contentLabel.text;
                //创建图片内容对象
                UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //如果有缩略图，则设置缩略图
                shareObject.thumbImage = [UIImage imageNamed:@"header"];
               
                [shareObject setShareImage:image];
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ  messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                    }
                }];
            }
                break;
                
            case UMSocialPlatformType_Sina:
                
            {
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                messageObject.text = _contentLabel.text;
                //创建图片内容对象
                UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //如果有缩略图，则设置缩略图
                shareObject.thumbImage = [UIImage imageNamed:@"header"];
                
                [shareObject setShareImage:image];
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina  messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                    }
                }];
                
            }
                break;
                
            case UMSocialPlatformType_WechatTimeLine:
                
            {
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
        
        
        
        
        
        
    }];//显示分享面板
    
    
   
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
