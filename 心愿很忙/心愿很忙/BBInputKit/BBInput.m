//
//  BBInput.m
//  SoloVideo
//
//  Created by 项羽 on 16/9/22.
//  Copyright © 2016年 项羽. All rights reserved.
//

#import "BBInput.h"
#import "BBInputView.h"


@implementation BBInput



+ (BBInputView*)inputView {
    static dispatch_once_t once;
    
    static BBInputView *inputView;
#if !defined(BB_APP_EXTENSIONS)
    dispatch_once(&once, ^{ inputView = [[BBInputView alloc] init];});
#else
    dispatch_once(&once, ^{ inputView = [[BBInputView alloc] init]; });
#endif
    
    inputView.cancelHandler = ^{
        [BBInput dismissKeyboardAndBgBtutton:[self backgroundView]];
    };
    
    
    
    return inputView;
}


+ (UIButton*)backgroundView {
    static dispatch_once_t once;
    
    static UIButton *backgroundView;
#if !defined(BB_APP_EXTENSIONS)
    dispatch_once(&once, ^{ backgroundView = [[UIButton alloc] init];});
#else
    dispatch_once(&once, ^{ backgroundView = [[UIButton alloc] init];});
#endif
    
    backgroundView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:0.5];
    backgroundView.frame = [UIScreen mainScreen].bounds;
    [backgroundView addTarget:self action:@selector(dismissKeyboardAndBgBtutton:) forControlEvents:UIControlEventTouchUpInside];
    
    return backgroundView;
}


+(void)showInput:(ConfirmBlock)confirmHandler{

    [[UIApplication sharedApplication].keyWindow addSubview:[self backgroundView]];
    
    UITextView *inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    inputTextView.inputAccessoryView = [self inputView];
    [[self backgroundView] addSubview:inputTextView];
    
    [inputTextView becomeFirstResponder];
    [[self inputView].aTextView becomeFirstResponder];
    
    
    [self inputView].confirmHandler = ^(NSString *inputContent){
        
        [BBInput dismissKeyboardAndBgBtutton:[self backgroundView]];
        confirmHandler(inputContent);
    };
}


+(void)dismissKeyboardAndBgBtutton:(UIButton *)sender{
    
    [[self inputView].aTextView resignFirstResponder];
    [sender removeFromSuperview];
}


+(void)setNormalContent:(NSString *)content{
    
    [self inputView].aTextView.text = content;
}


+(void)setMaxContentLength:(NSInteger)lenght{
    
    [self inputView].maxLength = lenght;
}

+(void)setDescTitle:(NSString *)descTitle{
    
    [self inputView].descTitleLabel.text = descTitle;
}



@end
