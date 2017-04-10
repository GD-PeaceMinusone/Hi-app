//
//  WSIRegisterViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRegisterViewController.h"

@interface WSIRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation WSIRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
