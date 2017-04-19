//
//  DemoCell.h
//  CCFoldCellDemo
//
//  Created by eHome on 17/2/23.
//  Copyright © 2017年 Bref. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFoldCell.h"
#import "ListObject.h"

@interface DemoCell : CCFoldCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)ListObject *itObj;
@property (weak, nonatomic) IBOutlet UIImageView *thingIv;


- (void)setNumber:(NSInteger)number;

@end
