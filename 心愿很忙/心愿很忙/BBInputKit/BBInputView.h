//
//  BBInputView.h
//  SoloVideo
//
//  Created by 项羽 on 16/9/22.
//  Copyright © 2016年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();
typedef void(^ConfirmBlock)(NSString *inputContent);

@interface BBInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *aTextView;

@property (nonatomic,copy)CancelBlock cancelHandler;
@property (nonatomic,copy)ConfirmBlock confirmHandler;

//输入文字的最大长度
@property (nonatomic,assign)NSInteger maxLength;


@property (weak, nonatomic) IBOutlet UILabel *descTitleLabel;

@end
