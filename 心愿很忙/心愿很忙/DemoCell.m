//
//  DemoCell.m
//  CCFoldCellDemo
//
//  Created by eHome on 17/2/23.
//  Copyright © 2017年 Bref. All rights reserved.
//

#import "DemoCell.h"
#import "LSActionSheet.h"
#import <UIImageView+WebCache.h>
#import "LYPhotoBrowser.h"
#import "LYPhoto.h"
#import "HUDUtils.h"



@implementation DemoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.foregroundView.layer.cornerRadius = 10;
    self.foregroundView.layer.masksToBounds = YES;
    self.scrollView.contentSize = CGSizeMake(0, 1000);
}





-(void)setItObj:(ListObject *)itObj {

    _itObj = itObj;
    
    self.contentLabel.text = itObj.thingContent;
    NSURL *url = [NSURL URLWithString:itObj.thingPath];

    [self.thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)smileButton:(id)sender {

    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:@[@"查看详情",@"帮她/他实现"] block:^(int index) {
        
        
    }];

}
- (IBAction)button:(UIButton *)sender {
 

    
    LYPhoto *photo = [LYPhoto photoWithImageView:self.thingIv placeHold:self.thingIv.image photoUrl:nil];
    
    [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
}

- (void)setNumber:(NSInteger)number
{
    
}

- (NSTimeInterval)animationDurationWithItemIndex:(NSInteger)itemIndex animationType:(AnimationType)type
{
    NSArray<NSNumber *> *array = @[@(0.5f),@(.25f),@(.25f)];
    return array[itemIndex].doubleValue;
}

@end
