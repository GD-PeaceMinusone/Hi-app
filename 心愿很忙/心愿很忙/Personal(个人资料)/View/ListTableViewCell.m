//
//  ListTableViewCell.m
//  Hi
//
//  Created by Jackeylove on 2017/5/15.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "ListTableViewCell.h"
#import "WclEmitterButton.h"
#import "SRActionSheet.h"
#import "LYPhoto.h"
#import "LYPhotoBrowser.h"
#import "WSICommentViewController.h"

@interface ListTableViewCell ()

/**宝贝链接*/
@property(nonatomic,strong)  NSString *wishLink;
/**赞*/
@property (weak, nonatomic) IBOutlet UILabel *likeAmount;
/**评论*/
@property (weak, nonatomic) IBOutlet UILabel *commentAmount;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**发表时间*/
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
/**总赞数*/
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
/**总评论数*/
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
/**+1-1*/
@property (nonatomic,assign) NSInteger like;
/**点赞按钮*/
@property (weak, nonatomic) IBOutlet WclEmitterButton *starBt;
/**date*/
@property(nonatomic,strong)NSDate *date;

@property(nonatomic,strong)WSICommentViewController *commentVc;

@end


@implementation ListTableViewCell
static NSString *dbName = @"Wish_List.sqlite";
static NSString *notiName2 = @"comment";
static NSString *notiName3 = @"changeTabbar";

-(WSICommentViewController *)commentVc {
    
    if (!_commentVc) {
        
        _commentVc =[[WSICommentViewController alloc]init];
    }
    
    return _commentVc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContentLabel];
    [self addGesture];
    
    [_headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
}


-(void)setAvObj:(WishModel *)avObj {
    
    _avObj = avObj;
    
    if (!avObj) { //如果model 为空 则不处理 防止程序crash
        
        return;
    }
    
    //1.获得数据库文件的路径
    NSString *fmdbPath = DocumentPath;
    
    NSString *fileName = [fmdbPath stringByAppendingPathComponent: dbName];
    
    NSLog(@"path:  %@", fileName);
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    if ([db open]) {
        
        NSLog(@"数据库已打开");
        
        //根据条件查询
        FMResultSet *resultSet = [db executeQuery:@"select * from Wish_List where objectId=?;",_avObj.objectId];
        
        if (resultSet) { // 如果数据库中有这条状态的缓存 直接加载缓存

            while ([resultSet next]) {
                
                [_contentLabel setText:[resultSet stringForColumn:@"content"]];
                [_currentTime setText:avObj.createdAt];
                
                NSData *data = [resultSet dataForColumn:@"fileUrl"];
                UIImage *image = [UIImage imageWithData:data];
                [_thingIv setImage:image];
                
                NSURL *url = [NSURL URLWithString:[resultSet stringForColumn:@"headUrl"]];
                [_headerIv sd_setImageWithURL:url placeholderImage:nil completed:nil];
                
                [_nickName setText:[resultSet stringForColumn:@"nickName"]];
            }
            
            
        } else { // 如果数据库中没这条状态的缓存 从服务器请求
        
            [_contentLabel setText:avObj.comment]; //设置配图内容
            
            [_currentTime setText:avObj.createdAt]; //设置发表时间
            
            NSURL *url = [NSURL URLWithString:avObj.picUrl];
            
            [_thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
            
            [query getObjectInBackgroundWithId:_avObj.user.objectId block:^(BmobObject *object, NSError *error) {
                
                NSString *headStr = [object objectForKey:@"userHeader"];
                
                [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
                
                [_nickName setText:[object objectForKey:@"nickName"]]; //设置昵称
                
            }];
        }
  
        
    }else {
        
        NSLog(@"数据库未打开");
    }
    

    
    //查询对应状态的总赞数
    
    BmobQuery *allQuery = [BmobQuery queryWithClassName:@"Praise"];
    
    [allQuery whereKey:@"comment" equalTo:_avObj.avObj];
    
    [allQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        
        _like = number;
        [_likeCount setText:[NSString stringWithFormat:@"%d", number]];
        
    }];
    
    
    //判断当前状态是否被当前用户赞过 如果赞过 则无论何时图标都显示selected状态
    
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query2 whereKey:@"comment" equalTo:_avObj.avObj];
    
    BmobQuery *addQuery = [BmobQuery queryWithClassName:@"Praise"];
    
    [addQuery add:query1];
    
    [addQuery add:query2];
    
    [addQuery andOperation];
    
    [addQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count == 0) {
            
            _starBt.selected = NO;
            
        }else {
            
            _starBt.selected = YES;
        }
        
        
    }];
    
}




/**
 *  弹出选择菜单
 */
- (IBAction)giftButton:(id)sender {
    
    if ([_avObj.user.objectId isEqualToString:[BmobUser currentUser].objectId]) {
        
        SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"选择"
                                                                    cancelTitle:@"取消"
                                                               destructiveTitle:nil
                                                                    otherTitles:@[@"心愿详情"]
                                                                    otherImages:nil
                                                               selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                                   
                                                                   if (index == 0) { //心愿详情
                                                                       
                                                                       
                                                                   }
                                                                   
                                                               }];
        
        [actionSheet show];
        
        
    }else {

        
        
        SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"选择"
                                                                    cancelTitle:@"取消"
                                                               destructiveTitle:nil
                                                                    otherTitles:@[@"心愿详情", @"帮她/他实现心愿"]
                                                                    otherImages:nil
                                                               selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                                   
                                                                   switch (index) {
                                                                       case 0:{
                                                                           
                                                                           //                    [self getLink];
                                                                           
                                                                       }
                                                                           break;
                                                                           
                                                                       case 1:
                                                                           
                                                                       {
                                                                           
                                                                           
                                                                       }
                                                                           
                                                                           break;
                                                                           
                                                                       default:
                                                                           break;
                                                                   }
                                                                   
                                                               }];
        
        [actionSheet show];
        
        
    }
    
}



/**
 *  实现label长按复制
 */

-(void)setupContentLabel {
    
    //让cell 不响应点击事件
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    longPress.minimumPressDuration = 0.5;
    
    [_contentLabel addGestureRecognizer:longPress];
}


-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return action == @selector(customCopy:);
}

- (void)customCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
    
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    
    [self becomeFirstResponder];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(customCopy:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}




/**
 *  点击查看大图
 */

-(void)addGesture {
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
 
    _thingIv.userInteractionEnabled = YES;
    [_thingIv addGestureRecognizer:tapGr];
    
}

-(void)tap{
    
    LYPhoto *photo = [LYPhoto photoWithImageView:self.thingIv placeHold:self.thingIv.image photoUrl:nil];
    
    [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
}


/**删除和分享*/

- (IBAction)shareAction:(id)sender {
    
    BmobUser *user = _avObj.user;
    
    if ([user.objectId isEqualToString:[BmobUser currentUser].objectId]) {
        
        SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                    cancelTitle:@"删除"
                                                               destructiveTitle:nil
                                                                    otherTitles:@[@"分享"]
                                                                    otherImages:nil
                                                               selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                                   
                                                                   if (index == 0) {
                                                                       
                                                                       
                                                                       
                                                                       
                                                                   }else if(index == 1) {
                                                                       
                                                                       
                                                                       
                                                                   }else {
                                                                       
                                                                   }
                                                                   
                                                               }];
        
        [actionSheet show];
        
    }else {
        
       
    }
    
    
}


/**实现点赞功能*/
- (IBAction)wclButtonAction:(UIButton *)sender {

    /**构建查询条件 如已点过赞 将不再增加数据 并将该条数据从后台delete*/
    
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query2 whereKey:@"comment" equalTo:_avObj.avObj];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Praise"];
    
    [query add:query1];
    
    [query add:query2];
    
    [query andOperation];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count == 0) {
            
            BmobObject *obj = [BmobObject objectWithClassName:@"Praise"];
            
            [obj setObject:[BmobUser currentUser] forKey:@"starUser"];
            [obj setObject:_avObj.avObj forKey:@"comment"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    
                    NSLog(@"点赞成功");
                    [_likeCount setText:[NSString stringWithFormat:@"%ld", _like + 1]];
                    _like += 1;
                    
                }else {
                    
                    NSLog(@"点赞失败---%@", error);
                    
                }
                
            }];
            
            
        }else {
            
            NSLog(@"已经赞过");
            [array[0] deleteInBackground];
            [_likeCount setText:[NSString stringWithFormat:@"%ld", _like - 1]];
            _like -= 1;
        }
        
        
    }];
    
    
}


- (IBAction)commentBt:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName2 object:@[@(_headerIv.tag),self.commentVc]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName3 object:nil];
    
    [[UIViewController getNavi] pushViewController:self.commentVc animated:YES];
}






@end
