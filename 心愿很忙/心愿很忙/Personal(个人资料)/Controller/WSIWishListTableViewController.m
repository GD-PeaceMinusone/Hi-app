//
//  WSIWishListTableViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/13.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIWishListTableViewController.h"
#import "MJRefresh.h"
#import "ListTableViewCell.h"
#import "WSICommentViewController.h"

@interface WSIWishListTableViewController ()
@property(nonatomic,strong)NSMutableArray *itObjs;
@end

@implementation WSIWishListTableViewController
static NSString *dbName = @"Wish_List.sqlite";
static NSString *ListCell = @"ListCell";
static NSString *notiName = @"comment2";

-(NSMutableArray *)itObjs {

    if (!_itObjs) {
        
        _itObjs = [NSMutableArray array];
    }
    
    return _itObjs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    [self loadNewTopics];
    [self registerCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVc:) name:notiName object:nil];
}


-(void)pushVc: (NSNotification*)noti {//接受传过来的Vc 通过tag给对应vc赋值
    
    NSInteger index = [noti.object[0] integerValue];
    WSICommentViewController *commentVc = noti.object[1];
    commentVc.avObj = self.itObjs[index];
}

-(void)registerCell {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ListCell"];
}

-(void)setupRefresh {

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];

    header.lastUpdatedTimeLabel.hidden =YES;
    
    header.automaticallyChangeAlpha = YES;
    
    header.stateLabel.hidden = YES;

    self.tableView.mj_header = header;
  
}


-(void)loadNewTopics {

    BmobQuery *query = [BmobQuery queryWithClassName:@"WishList"];
    
    [query whereKey:@"wishUser" equalTo:[BmobUser currentUser]];
    
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"----%@---", error);
            
            [HUDUtils setupErrorWithStatus:@"加载失败" WithDelay:1.5f completion:^{
                
                WSIWeakSelf
                [weakSelf.tableView.mj_header endRefreshing];
                
            }];
        }{
            
            if (objects.count == 0) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData]; //当没有数据返回时 显示加载完毕状态
                
                WSIWeakSelf
                [weakSelf.tableView.mj_header endRefreshing];
                
                return;
            }
            
            self.itObjs = [[WishModel wishObjectArrayFromAvobjectArrary:objects] mutableCopy];
            [self.tableView reloadData];

            WSIWeakSelf
           [weakSelf.tableView.mj_header endRefreshing];
        }
    
    }];
    
    
}


#pragma mark - Table view data source

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"scroll" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _itObjs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCell];
    
    cell.avObj = _itObjs[indexPath.row];
    
    cell.headerIv.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    WishModel *model = _itObjs[indexPath.row];
    
    return model.cellHeight;
}
@end
