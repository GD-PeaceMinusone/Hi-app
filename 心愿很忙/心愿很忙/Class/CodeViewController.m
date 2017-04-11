//
//  CodeViewController.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 2016/11/25.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CodeViewController.h"
#import "CCDraggableContainer.h"
#import "CustomCardView.h"
#import <Masonry.h>

@interface CodeViewController ()
<
CCDraggableContainerDataSource,
CCDraggableContainerDelegate
>

@property (nonatomic, strong) CCDraggableContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property(nonatomic,strong)CustomCardView *cardView;
@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadUI];
}

- (void)loadUI {
    // 防止视图变黑
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化Container
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 64, CCWidth, CCHeight) style:CCDraggableStyleDownOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    
    [self.view addSubview:self.container];
    // 重启加载
    [self.container reloadData];
}

- (void)loadData {
    
    _dataSources = [NSMutableArray array];
    
    
        NSDictionary *dict = @{
                               };
        [_dataSources addObject:dict];
    
}


#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    CustomCardView *cardView = [[CustomCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView installData:[_dataSources objectAtIndex:index]];
    cardView.backgroundColor = [UIColor whiteColor];
    
    //关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closePublish) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮视图
    UIImage *image = [UIImage imageNamed:@"关闭"];
    UIImageView *imageVeiw = [[UIImageView alloc]initWithImage:image];
    
    //内容视图
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.contentSize = CGSizeMake(0, 600);
    
    //底部栏
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    //分割线
    UIView *view2 = [UIView new];
    CGFloat viewBg = 160.0f / 255.0f;
    view2.backgroundColor = [UIColor colorWithRed:viewBg green:viewBg blue:viewBg alpha:1.00];;
    
    //头像
    UIImageView *headerIv = [UIImageView new];
    [headerIv setImage:[UIImage imageNamed:@"header"]];
    
    //昵称
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"越克制越上瘾";
    nickNameLabel.font = [UIFont systemFontOfSize:15];
    
    //个签
    UILabel *signLabel = [UILabel new];
    signLabel.text = @"像个路人般看热闹";
    signLabel.font = [UIFont systemFontOfSize:13];
    signLabel.textColor = [UIColor lightGrayColor];
    
    //发布按钮
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮视图
    UIImage *image2 = [UIImage imageNamed:@"心愿单"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image2];
    
    
    [cardView addSubview:scrollView];
    [cardView addSubview:view];
    [view addSubview:view2];
    [view addSubview:headerIv];
    [view addSubview:nickNameLabel];
    [view addSubview:signLabel];
    [view addSubview:publishButton];
    [publishButton addSubview:imageView];
    [closeButton addSubview:imageVeiw];
    [cardView addSubview:closeButton];
    
    /*使用masonry设置约束**/
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(cardView.xmg_width, 105));
        make.bottom.equalTo(cardView).with.offset(0);
        
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(cardView.xmg_width, 176.0f / 255.0f));
        make.bottom.equalTo(cardView.mas_bottom).with.offset(-106);
    }];
    
    [headerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(60, 60));;
        make.left.equalTo(view).with.offset(30);
        make.bottom.equalTo(view).with.offset(-23);
    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.mas_equalTo(headerIv.mas_right).with.offset(20);
        make.top.mas_equalTo(view.mas_top).with.offset(30);
        
    }];
    
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.mas_equalTo(headerIv.mas_right).with.offset(20);
        make.top.mas_equalTo(nickNameLabel.mas_bottom).with.offset(-1);
        
    }];
    
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(view).with.offset(0);
        make.right.equalTo(view).with.offset(-15);
        
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.center.equalTo(publishButton);
     
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(cardView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    [imageVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.center.equalTo(closeButton);
        
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(cardView).with.offset(5);
        make.right.equalTo(cardView).with.offset(-5);
    }];
    
    
    
    return cardView;
}

-(void)closePublish {
    
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        // self.disLikeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        // self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    

}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    
    [draggableContainer reloadData];
}

@end
