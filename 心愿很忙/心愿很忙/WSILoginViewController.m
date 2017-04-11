//
//  WSILoginViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSILoginViewController.h"
#import "WSIRegisterViewController.h"
#import <Masonry.h>

@interface WSILoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation WSILoginViewController

- (void)viewDidLoad {
    
    [self setupImageView];
    [self setupConerRadius];
    
}

-(void)setupConerRadius {

    [self.loginView.layer setCornerRadius:4.0f];
    [self.loginButton.layer setCornerRadius:3.0f];
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

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)Register:(UIButton *)sender {
    
    WSIRegisterViewController *registerVc = [[WSIRegisterViewController alloc]initWithNibName:@"WSIRegisterViewController" bundle:[NSBundle mainBundle]];
    
    [self presentViewController:registerVc animated:YES completion:nil];
}



@end
