//
//  BBInputView.m
//  SoloVideo
//
//  Created by 项羽 on 16/9/22.
//  Copyright © 2016年 项羽. All rights reserved.
//

#import "BBInputView.h"

@interface BBInputView()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UILabel *textNum;

@end

@implementation BBInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    self.bgView.layer.borderWidth = 1.0f;
    
    self.cancelBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.cornerRadius = 5;
    
    if (_maxLength <= 0) {
        _maxLength = 20;
    }
    
}

- (IBAction)cancelAct {
    
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}


- (IBAction)confirmAct {
    
    if (self.confirmHandler) {
        self.confirmHandler(self.aTextView.text);
    }
}



- (void)textViewDidBeginEditing:(UITextView *)textView;{
    
//    NSLog(@"------%ld",self.aTextView.text.length);
    
    self.textNum.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,(long)_maxLength];
}

- (void)textViewDidChange:(UITextView *)textView;{
    
    NSString *lang = textView.textInputMode.primaryLanguage;//键盘输入模式
    static NSInteger length = 0;
    if ([lang isEqualToString:@"zh-Hans"]){
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange) {//没有有高亮
            length = textView.text.length;
        }else{
            
        }
    }else{
        length = textView.text.length;
    }
    
    if (length > 0) {
        
        if (length > _maxLength) {
             textView.text = [textView.text substringToIndex:_maxLength];
            self.textNum.text = [NSString stringWithFormat:@"%ld/%ld",_maxLength,(long)_maxLength];
            return;
        }
        
        self.textNum.text = [NSString stringWithFormat:@"%ld/%ld",length,(long)_maxLength];
    }

}


-(void)setMaxLength:(NSInteger)maxLength{
    
    _maxLength = maxLength;
    if (_maxLength) {
        self.textNum.text = [NSString stringWithFormat:@"00/%ld",(long)_maxLength];
    }
}


@end
