//
//  AppDelegate.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MMDrawerController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(nonatomic,strong) MMDrawerController *drawer;

@property(nonatomic,strong)UIButton *publishButton;

- (void)saveContext;


@end

