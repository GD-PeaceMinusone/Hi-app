//
//  DemoCell.h
//  CCFoldCellDemo
//
//  Created by eHome on 17/2/23.
//  Copyright © 2017年 Bref. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFoldCell.h"

@interface DemoCell : CCFoldCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thingIv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (void)setNumber:(NSInteger)number;

@end
