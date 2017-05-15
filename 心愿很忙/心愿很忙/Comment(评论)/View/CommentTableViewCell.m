//
//  CommentTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "BBInput.h"
#import "revertModel.h"
#import "WSIPerosonalViewController.h"
#import "WSIMeDetailViewController.h"
#import "STPopupController.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *comHead;

@property (weak, nonatomic) IBOutlet UILabel *comContent;

@property (weak, nonatomic) IBOutlet UILabel *comTime;

@property(nonatomic,strong)NSMutableArray *revertArr;

@property(nonatomic,strong)NSMutableAttributedString *contentT;

@property (weak, nonatomic) IBOutlet YYLabel *nickName;

@property (weak, nonatomic) IBOutlet YYLabel *revertL3;

@property (weak, nonatomic) IBOutlet YYLabel *revertL4;

@property (weak, nonatomic) IBOutlet YYLabel *allRevert;

@property (weak, nonatomic) IBOutlet YYLabel *revertView;

@property (weak, nonatomic) IBOutlet YYLabel *revertL1;

@property (weak, nonatomic) IBOutlet YYLabel *revertL2;

@property (weak, nonatomic) IBOutlet UILabel *likeCount;

@property (weak, nonatomic) IBOutlet UIButton *starBt;

@property (nonatomic,assign) NSInteger like;

@property(nonatomic,strong)WSIPerosonalViewController *personVc;

@property(nonatomic,strong)STPopupController *popVc;

@end

@implementation CommentTableViewCell

static NSString *notiName = @"pushVc";

#pragma mark - 懒加载和赋值

-(WSIPerosonalViewController *)personVc {

    if (!_personVc) {
        
        _personVc = [WSIPerosonalViewController new];
    }
    
    return _personVc;
}


-(NSMutableArray *)revertArr {

    if (!_revertArr) {
        
        _revertArr = [NSMutableArray array];
    }
    
    return _revertArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
  
    [self setupGesture];
    
    // 设置button中图片尺寸
    
    [_starBt setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [_comHead circleHeader:_comHead withBorderWidth:0 andBorderColor:nil];
   
}

/** 手势 */

-(void)setupGesture {
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    
    [_comHead setUserInteractionEnabled:YES];
    
    [_comHead addGestureRecognizer:tapGr];
}


-(void)tap {
    
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:nil size:15], NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    WSIMeDetailViewController *meVc = [WSIMeDetailViewController new];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:@[@(_headerIv.tag),meVc]];

    _popVc = [[STPopupController alloc] initWithRootViewController:meVc];
    
    _popVc.containerView.layer.cornerRadius = 3.0f;
    
    [_popVc presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    [_popVc.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
}

-(void)backgroundViewDidTap {
    
    [_popVc dismiss];
    
}


/** 抽取设置富文本的方法 */

-(NSMutableAttributedString*)setupAttributeWithnickName: (NSString*)nickName {
    
    if (nickName != nil) { //容错处理 防止程序崩溃
        
        _contentT = [[NSMutableAttributedString alloc]initWithString:nickName];
        
        [_contentT setYy_font:[UIFont systemFontOfSize:14.0f]];
        
        [_contentT yy_setTextHighlightRange:NSMakeRange(0,nickName.length) color:HiBlueColor backgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0f] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            [[UIViewController getNavi] pushViewController:self.personVc animated:YES];
            
        }];
        
    } else {
    
    
    }
    
    
    return _contentT;
}


-(void)setComModel:(commentModel *)comModel {

    _comModel = comModel;
    
    if (!comModel) {
        
        return;
    }
 
    [_comContent setText:comModel.content]; //设置配图文字

    [_comTime setText:[NSString stringWithFormat:@"%@", comModel.commentTime]]; //设置时间
    
    
    // 设置评论人信息
    
    BmobQuery *q = [BmobQuery queryWithClassName:@"_User"];
    
    [q getObjectInBackgroundWithId:comModel.user.objectId block:^(BmobObject *object, NSError *error) {

        
        [_nickName setAttributedText:[self setupAttributeWithnickName:[object objectForKey:@"nickName"]]];
        NSString *str = [object objectForKey:@"userHeader"];
        
        [_comHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
 
    }];
    
    
    //查询对应状态的总赞数
    
    BmobQuery *allQuery = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [allQuery whereKey:@"comment" equalTo:comModel.comObj];
    
    [allQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        
        _like = number;
        [_likeCount setText:[NSString stringWithFormat:@"%d", number]];
        
        if ([_likeCount.text integerValue] == -1) {
            
             [_likeCount setText:[NSString stringWithFormat:@"%d", 0]];
        }
        
    }];
    
    
    //判断当前状态是否被当前用户赞过 如果赞过 则无论何时图标都显示selected状态
    
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [query2 whereKey:@"comment" equalTo:comModel.comObj];
    
    BmobQuery *addQuery = [BmobQuery queryWithClassName:@"commentPraise"];
    
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


- (IBAction)likeBt:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    /**构建查询条件 如已点过赞 将不再增加数据 并将该条数据从后台delete*/
    
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [query2 whereKey:@"comment" equalTo:_comModel.comObj];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"commentPraise"];
    
    [query add:query1];
    
    [query add:query2];
    
    [query andOperation];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count == 0) {
            
            BmobObject *obj = [BmobObject objectWithClassName:@"commentPraise"];
            
            [obj setObject:[BmobUser currentUser] forKey:@"starUser"];
            [obj setObject:_comModel.comObj forKey:@"comment"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    
                    NSLog(@"评论点赞成功");
                    [_likeCount setText:[NSString stringWithFormat:@"%ld", _like + 1]];
                    _like += 1;
                    
                }else {
                    
                    NSLog(@"评论点赞失败---%@", error);
                    
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

- (IBAction)revert:(id)sender {
  
    [BBInput setDescTitle:@"回复"];
    [BBInput setMaxContentLength:140];
    [BBInput showInput:^(NSString *inputContent) {
   
        BmobObject *wishObj = [[BmobObject alloc] initWithClassName:@"Revert"]; //建表
        [wishObj setObject:inputContent forKey:@"content"]; //回复内容
        [wishObj setObject:_comModel.comObj forKey:@"comment"]; //回复的对应的评论
        [wishObj setObject:[BmobUser currentUser] forKey:@"wishUser"]; //回复人
        
        [wishObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                NSLog(@"回复成功");
                
                [BBInput setNormalContent:nil];
                [self resignFirstResponder];
                
            }else {
                
                NSLog(@"评论失败");
            }
            
        }];
    
       
    }];
    
}



@end
