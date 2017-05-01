//
//  DemoCell.m
//  CCFoldCellDemo
//
//  Created by eHome on 17/2/23.
//  Copyright © 2017年 Bref. All rights reserved.
//

#import "DemoCell.h"
#import <UIImageView+WebCache.h>
#import "LYPhotoBrowser.h"
#import "LYPhoto.h"
#import "HUDUtils.h"



@implementation DemoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.foregroundView.layer.cornerRadius = 10;
    self.foregroundView.layer.masksToBounds = YES;
   
    self.scrollView.contentSize = CGSizeMake(0, 2000);
    self.thingIv.clipsToBounds = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
