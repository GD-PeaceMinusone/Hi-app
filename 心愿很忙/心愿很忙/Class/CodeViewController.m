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
#import <YYText.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <TZImagePickerController.h>

@interface CodeViewController ()
<
CCDraggableContainerDataSource,
CCDraggableContainerDelegate,
UIScrollViewDelegate,
TZImagePickerControllerDelegate
>

@property (nonatomic, strong) CCDraggableContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property(nonatomic,strong)CustomCardView *cardView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIImageView *imageVeiw;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)UIImageView *headerIv;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *signLabel;
@property(nonatomic,strong)UIButton *publishButton;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *slider1;
@property(nonatomic,strong)UIImageView *circleImageView;
@property(nonatomic,strong)UIImageView *circleImageView2;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UIView *view3;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *view4;
@property(nonatomic,strong)UIImageView *imageView3;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UIImageView *view6;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UILabel *label4;
@property(nonatomic,strong)UIView *tv1View;
@property(nonatomic,strong)UITextView *tv1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIView *tv2View;
@property(nonatomic,strong)UITextView *tv2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)UILabel *label5;
@property(nonatomic,strong)UIButton *button4;
@property(nonatomic,strong)NSArray *images;
@property (nonatomic,assign)NSInteger pickerCount;
@property (nonatomic,assign) NSInteger selectedCount;
//@property(nonatomic,strong)UIImageView *contentIv1;
//@property(nonatomic,strong)UIImageView *contentIv2;
@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadUI];
    
    
    
}

- (void)loadUI {
    // 防止视图变黑
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:242.0/255 blue:244.0/255 alpha:1];
    
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
    
     NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"BG5"],
                           };
     [_dataSources addObject:dict];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.scrollView endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.scrollView endEditing:YES];
}

#pragma mark - 设置阴影
-(void)setupShadowWithObj: (UIView*)view {

    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0].CGColor;
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 6.f;
    
}

#pragma mark - lazyLoading

-(NSInteger)selectedCount {

    if (!_selectedCount) {
        
        _selectedCount = 0;
    }
    
    return _selectedCount;
}

-(NSInteger)pickerCount {

    if (!_pickerCount) {

        _pickerCount = 0;
    }
    return _pickerCount;
}

-(UIScrollView *)scrollView {

    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(0, 1500);
        _scrollView.delegate= self;
    }
    
    return _scrollView;
}

-(UIButton *)closeButton {

    if (!_closeButton) {
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closePublish) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

-(UIImageView *)imageVeiw {

    if (!_imageVeiw) {
        
        UIImage *image = [UIImage imageNamed:@"关闭"];
        _imageVeiw = [[UIImageView alloc]initWithImage:image];
    }
    
    return _imageVeiw;
}

-(UIView *)view1 {

    if (!_view1) {
        
        _view1 = [UIView new];
       _view1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f];
    }
    
    return _view1;
}


-(UIView *)view2 {//分割线
    
    if (!_view2) {
        
        _view2 = [UIView new];
        _view2.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f];
    }
    
    return _view2;
}

-(UIImageView *)headerIv {

    if (!_headerIv) {
        
        _headerIv = [UIImageView new];
        [_headerIv setImage:[UIImage imageNamed:@"header"]];
    }
    
    return _headerIv;
}


#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    CustomCardView *cardView = [[CustomCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView installData:[_dataSources objectAtIndex:index]];
    cardView.backgroundColor = [UIColor whiteColor];
    
    //关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closePublish) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮视图
    UIImage *image = [UIImage imageNamed:@"关闭"];
    self.imageVeiw = [[UIImageView alloc]initWithImage:image];
    
    //内容视图
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.contentSize = CGSizeMake(0, 1500);
    self.scrollView.delegate= self;
    //底部栏
    self.view1 = [UIView new];
    self.view1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f];

    //头像
    self.headerIv = [UIImageView new];
    [self.headerIv setImage:[UIImage imageNamed:@"header"]];
    
    //昵称
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.text = @"越克制越上瘾";
    self.nickNameLabel.font = [UIFont systemFontOfSize:15];
    
    //个签
    self.signLabel = [UILabel new];
    self.signLabel.text = @"像个路人般看热闹";
    self.signLabel.font = [UIFont systemFontOfSize:13];
    self.signLabel.textColor = [UIColor lightGrayColor];
    
    //发布按钮
    self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮视图
    UIImage *image2 = [UIImage imageNamed:@"心愿单"];
    self.imageView = [[UIImageView alloc]initWithImage:image2];
    
    //分割线1
    self.slider1 = [UIView new];
    self.slider1.backgroundColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0];
    
    //顶部圆圈1
    UIImage *image3 = [UIImage imageNamed:@"圆圈"];
    self.circleImageView = [[UIImageView alloc]initWithImage:image3];
    
    //顶部圆圈2
    UIImage *image4 = [UIImage imageNamed:@"圆圈"];
    self.circleImageView2 = [[UIImageView alloc]initWithImage:image4];
    
    //封面
    self.label1 = [UILabel new];
    [self.label1 setText:@"封面"];
    [self.label1 setFont:[UIFont systemFontOfSize:15]];
    
    //封面内容
    self.view3 = [UIView new];
    [self setupShadowWithObj:self.view3];
    
    //输入框
    UITextView *textView = [[UITextView alloc]init];

    //输入框下划线
    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0];
    
    //标题图案
    UIImage *image5 = [UIImage imageNamed:@"圆圈"];
    self.imageView3 = [[UIImageView alloc]initWithImage:image5];
    
    //标题
    self.label2 = [UILabel new];
    [self.label2 setText:@"标题"];
    [self.label2 setFont:[UIFont systemFontOfSize:13]];
    
    //内部view
    self.view6 = [UIImageView new];
    self.view6.backgroundColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0];
    
    //封面图片
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.tag = 1;
    [self.button setImage:[UIImage imageNamed:@"图片"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(selectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button4.tag = 4;
    [self.button4 setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.button4 addTarget:self action:@selector(selectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //事情
    self.label3 = [UILabel new];
    [self.label3 setText:@"事情"];
    [self.label3 setFont:[UIFont systemFontOfSize:15]];
    
    //title
    self.label4 = [UILabel new];
    self.label4.text = @"遗憾和自责的事";
    self.label4.font = [UIFont systemFontOfSize:13];
    self.label4.textColor = [UIColor lightGrayColor];
    
    //内容1
//    self.contentIv1 = [UIImageView new];
//    [self.contentIv1 setImage:[UIImage imageNamed:@"IMG_1962"]];
    
    self.tv1View= [UIView new];
    [self setupShadowWithObj:self.tv1View];
    
    self.tv1 = [UITextView new];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.tag = 2;
    [self.button2 setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(selectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //内容2
//    self.contentIv2 = [UIImageView new];
//    [self.contentIv2 setImage:[UIImage imageNamed:@"IMG_1962"]];
    
    UIView *tv2View= [UIView new];
    [self setupShadowWithObj:tv2View];
    
    self.tv2 = [UITextView new];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3.tag = 3;
    [self.button3 setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.button3 addTarget:self action:@selector(selectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //title
    self.label5 = [UILabel new];
    self.label5.text = @"不管怎么样一定会去实现的事";
    self.label5.font = [UIFont systemFontOfSize:13];
    self.label5.textColor = [UIColor lightGrayColor];
    
    [cardView addSubview:self.scrollView];
    [self.scrollView addSubview:self.slider1];
    [self.scrollView addSubview:self.circleImageView];
    [self.scrollView addSubview:self.self.circleImageView2];
    [self.scrollView addSubview:self.label1];
    [self.scrollView addSubview:self.view3];
    [self.scrollView addSubview:self.button4];
    [self.view3 addSubview:textView];
    [self.view3 addSubview:view4];
    [self.view3 addSubview:self.imageView3];
    [self.view3 addSubview:self.label2];
    [self.view3 addSubview:self.view6];
    [self.view3 addSubview:self.button];
    [cardView addSubview:self.view1];
//    [self.scrollView addSubview:self.contentIv1];
    [self.scrollView addSubview:self.tv1View];
    [self.scrollView addSubview:self.label3];
//    [self.scrollView addSubview:self.contentIv2];
    [self.scrollView addSubview:tv2View];
    [self.scrollView addSubview:self.label4];
    [self.scrollView addSubview:self.label5];
    [self.scrollView addSubview:self.button2];
    [self.scrollView addSubview:self.button3];
    [self.tv1View addSubview:self.tv1];
    [tv2View addSubview:self.tv2];
    [self.view1 addSubview:self.view2];
    [self.view1 addSubview:self.headerIv];
    [self.view1 addSubview:self.nickNameLabel];
    [self.view1 addSubview:self.signLabel];
    [self.view1 addSubview:self.publishButton];
    [self.publishButton addSubview:self.imageView];
    [self.self.closeButton addSubview:self.imageVeiw];
    [cardView addSubview:self.self.closeButton];
    
    /*使用masonry设置约束**/
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(cardView.xmg_width, 105));
        make.bottom.equalTo(cardView).with.offset(0);
        
    }];
    
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(cardView.xmg_width, 176.0f / 255.0f));
        make.bottom.equalTo(cardView.mas_bottom).with.offset(-106);
    }];
    
    [self.headerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(60, 60));;
        make.left.equalTo(self.view1).with.offset(30);
        make.bottom.equalTo(self.view1).with.offset(-23);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.mas_equalTo(self.headerIv.mas_right).with.offset(20);
        make.top.mas_equalTo(self.view1.mas_top).with.offset(30);
        
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.mas_equalTo(self.headerIv.mas_right).with.offset(20);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).with.offset(-1);
        
    }];
    
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.view1).with.offset(0);
        make.right.equalTo(self.view1).with.offset(-15);
        
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.center.equalTo(self.publishButton);
     
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(cardView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    [self.slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(1, 600));
        make.top.equalTo(self.scrollView).with.offset(40);
        make.left.equalTo(self.scrollView).with.offset(40);
    }];
    
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.bottom.mas_equalTo(self.slider1.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.slider1.mas_centerX);
        
    }];
    
    [self.self.circleImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.top.mas_equalTo(self.slider1.mas_top).with.offset(300);
        make.centerX.mas_equalTo(self.slider1.mas_centerX);
        
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(39,15));
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        make.top.mas_equalTo(self.circleImageView.mas_top);
        
    }];
    
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 250));
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        make.top.mas_equalTo(self.label1.mas_bottom).with.offset(20);
    }];
    
    [self.view6 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(140, 140));
        make.centerX.mas_equalTo(self.view3.mas_centerX);
        make.top.mas_equalTo(self.view3.mas_top).with.offset(30);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(140, 25));
        make.top.mas_equalTo(self.view6.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view6.mas_centerX);
    }];
    
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(140, 1));
        make.top.mas_equalTo(textView.mas_bottom);
        make.centerX.mas_equalTo(self.view6.mas_centerX);
    }];
    
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.top.mas_equalTo(view4.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.view3.mas_left).with.offset(75);
        
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(30,15));
        make.left.mas_equalTo(self.imageView3.mas_left).with.offset(17);
        make.top.mas_equalTo(view4.mas_bottom).with.offset(7.5f);
        
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(self.view3.mas_centerX);
        make.top.mas_equalTo(self.view6.mas_top).with.offset(55);
    }];
    
    [self.imageVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.center.equalTo(self.self.closeButton);
        
    }];
    
//    [self.contentIv1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(250, 150));
//        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
//        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(60);
//        
//    }];
//    
//    
//    [self.contentIv2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(250, 150));
//        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
//        make.top.mas_equalTo(self.tv1View.mas_bottom).with.offset(60);
//        
//    }];
    
    [self.tv1View mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(80);
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        
    }];
    
    [self.tv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(80);
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self.tv1View.mas_bottom).with.offset(5);
        make.trailing.mas_equalTo(self.tv1View.mas_trailing);
    }];
    
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(39,15));
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        make.top.mas_equalTo(self.self.circleImageView2.mas_top);
        
    }];
    
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(self.tv1View.mas_top).with.offset(-6);
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
    }];
    
    [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.bottom.mas_equalTo(tv2View.mas_top).with.offset(-6);
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
    }];
    
    
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(tv2View.mas_bottom).with.offset(5);
        make.trailing.mas_equalTo(tv2View.mas_trailing);
        
    }];
    
    [self.button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(5);
        make.trailing.mas_equalTo(self.view3.mas_trailing);
        
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(cardView).with.offset(5);
        make.right.equalTo(cardView).with.offset(-5);
    }];
    
   
    
    return cardView;
}

#pragma mark - 设置输入框约束

-(void)setupLayoutWithNumber:(NSInteger)number {
    
    
    [self.tv1View mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(80 + 170*number);
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        
        
    }];
    
    [self.tv1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
        make.top.mas_equalTo(self.view3.mas_bottom).with.offset(80 + 170*number);
        
    }];
    
    [self.button2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self.tv1View.mas_bottom).with.offset(5);
        make.trailing.mas_equalTo(self.tv1View.mas_trailing);
        
    }];
    
}

#pragma mark - 监听点击事件

-(void)closePublish {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        self.pickerCount = 0;
    }];
}

-(void)selectedPhoto: (UIButton *)button {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 delegate:self];
    
   
    //拿到选择的照片
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        self.images = photos;
        
        self.pickerCount += self.images.count;
        
        switch (button.tag) {
                
            case 1:
                
            {
                if (self.view6.image) {
                    
                    button.hidden = NO;
                    
                }else {
                    
                    self.view6.image = _images[0];
                    button.hidden = YES;
                }
            
            
            }
                break;
                
            case 2:
                
            {
                
                if (_selectedCount == 0) {//第一次选择图片
                    
                    self.selectedCount +=1;
                    
                    for (int i = 0; i<self.images.count; i++) {
                        
                        for (UIImage *image in self.images) {
                            
                            UIImageView *imageView = [UIImageView new];
                            imageView.image = image;
                            [self.scrollView addSubview:imageView];
                            
                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [imageView addSubview:button];
                            [button setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
                            [button addTarget:self action:@selector(closeIv) forControlEvents:UIControlEventTouchUpInside];
                        
                            
                            //设置图片框约束
                            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                                
                                make.size.mas_equalTo(CGSizeMake(250, 150));
                                make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
                                make.top.mas_equalTo(self.view3.mas_bottom).with.offset(60 + 170*i);
                            }];
                            
                            //设置关闭按钮约束
                            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                                
                                make.size.mas_equalTo(CGSizeMake(20, 20));
                                make.top.mas_equalTo(imageView.mas_top).with.offset(10);
                                make.right.mas_equalTo(imageView.mas_right).with.offset(-10);
                                
                            }];
                            
                            //设置输入框约束
                            [self setupLayoutWithNumber:i + 1];
                            
                        }
                        
                    }
                    
                }
                
                
                else {//第一次之后选择图片
                
                    
                    if (self.pickerCount > 0) {//已经选择过图片
                        
                        for (NSInteger i = 0; i<self.images.count; i++) {
                            
                            for (UIImage *image in self.images) {
                                
                                UIImageView *imageView = [UIImageView new];
                                imageView.image = image;
                                [self.scrollView addSubview:imageView];
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [imageView addSubview:button];
                                [button setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
                                [button addTarget:self action:@selector(closeIv) forControlEvents:UIControlEventTouchUpInside];
                                
                                //设置图片框约束
                                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.size.mas_equalTo(CGSizeMake(250, 150));
                                    make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
                                    make.top.mas_equalTo(self.view3.mas_bottom).with.offset(60 + 170*(i+_pickerCount-self.images.count));
                                }];
                                
                                //设置关闭按钮约束
                                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.size.mas_equalTo(CGSizeMake(20, 20));
                                    make.top.mas_equalTo(imageView.mas_top).with.offset(10);
                                    make.right.mas_equalTo(imageView.mas_right).with.offset(-10);
                                    
                                }];
                                
                                [self setupLayoutWithNumber:(i+_pickerCount-self.images.count+1)];
                                
                            }
                            
                        }
                        
                    }else{//第一次之后还没选择图片
                        
                        
                        for (int i = 0; i<self.images.count; i++) {
                            
                            for (UIImage *image in self.images) {
                                
                                UIImageView *imageView = [UIImageView new];
                                imageView.image = image;
                                [self.scrollView addSubview:imageView];
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [imageView addSubview:button];
                                [button setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
                                [button addTarget:self action:@selector(closeIv) forControlEvents:UIControlEventTouchUpInside];
                                
                                //设置图片框约束
                                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.size.mas_equalTo(CGSizeMake(250, 150));
                                    make.left.mas_equalTo(self.slider1.mas_right).with.offset(20);
                                    make.top.mas_equalTo(self.view3.mas_bottom).with.offset(60 + 170*i);
                                }];
                                
                                //设置关闭按钮约束
                                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.size.mas_equalTo(CGSizeMake(20, 20));
                                    make.top.mas_equalTo(imageView.mas_top).with.offset(10);
                                    make.right.mas_equalTo(imageView.mas_right).with.offset(-10);
                                    
                                }];
                                
                                
                                
                                [self setupLayoutWithNumber:i + 1];
                                
                            }
                            
                        }
                        
                    }//else
                    
                    
                }//else
                
               
                
        }
                break;
                
            case 3:
                
            {
                
                
            }
                break;
                
            case 4:
                
            {
                if (self.view6.image) {
                    
                    button.hidden = NO;
                    
                }else {
                    
                    self.view6.image = _images[0];
                    button.hidden = YES;
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
        
        
        
    }];
    

    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark - 关闭按钮

-(void)closeIv {

    
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}




#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
//    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
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
