//
//  WSILoginViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSILoginViewController.h"
#import "WSIRegisterViewController.h"

@interface WSILoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation WSILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)Register:(UIButton *)sender {
    
    WSIRegisterViewController *registerVc = [[WSIRegisterViewController alloc]initWithNibName:@"WSIRegisterViewController" bundle:[NSBundle mainBundle]];
    
    [self presentViewController:registerVc animated:YES completion:nil];
}



@end
