//
//  WSIChattingViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/13.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIChattingViewController.h"
#import "WSIChatViewController.h"

@interface WSIChattingViewController ()
@property(nonatomic,strong)WSIChatViewController *chatVc;
@end

@implementation WSIChattingViewController

-(WSIChatViewController *)chatVc {

    if (!_chatVc) {
        
        _chatVc = [[WSIChatViewController alloc]init];
    }
    
    return _chatVc;
}

-(instancetype)init {

    self = [super init];
    
    if (self) {
        
        [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
    
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"0---%@", model);
    self.chatVc.conversationType = model.conversationType;
    self.chatVc.targetId = model.targetId;
    self.chatVc.title = model.conversationTitle;
    
    [[UIViewController getNavi] pushViewController:self.chatVc animated:YES];
}


@end

