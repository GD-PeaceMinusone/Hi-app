//
//  WSIRegisterViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRegisterViewController.h"

@interface WSIRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WSIRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConerRadius];
    [self setupImageView];
}

-(void)setupConerRadius {

    [self.registerView.layer setCornerRadius:4.0f];
    [self.codeButton.layer setCornerRadius:3.0f];
    [self.registerButton.layer setCornerRadius:3.0f];
    
}

/*对imageView进行半透明处理**/

-(void)setupImageView {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [UIScreen mainScreen].bounds;
    [self.imageView addSubview:effectView];
    
    UIVibrancyEffect *vibrancyView = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [effectView.contentView addSubview:visualEffectView];
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
