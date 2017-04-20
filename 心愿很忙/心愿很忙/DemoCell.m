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

@implementation DemoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.foregroundView.layer.cornerRadius = 10;
    self.foregroundView.layer.masksToBounds = YES;

}


//-(UIImageView *)thingIv {
//
//    if (!_thingIv) {
//        
//        _thingIv = [UIImageView new];
//        _thingIv.contentMode = UIViewContentModeScaleAspectFit;
//        _thingIv.frame = CGRectMake(50, 100, 200, 300);
//        _thingIv.backgroundColor = XMGRandomColor;
//        [self.contentView addSubview:_thingIv];
//    }
//    
//    return _thingIv;
//}


-(void)setItObj:(ListObject *)itObj {

    _itObj = itObj;
    
    self.contentLabel.text = itObj.thingContent;
    NSURL *url = [NSURL URLWithString:itObj.thingPath];
    [self.thingIv sd_setImageWithURL:url];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)smileButton:(id)sender {

    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:@[@"查看详情",@"帮她/他实现"] block:^(int index) {
        
        
    }];

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
