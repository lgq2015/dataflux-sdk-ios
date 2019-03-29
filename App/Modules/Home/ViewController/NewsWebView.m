//
//  NewsWebView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NewsWebView.h"
#import "WebItemView.h"
#import "NewsListModel.h"
#import "HandbookModel.h"
@interface NewsWebView ()
@property (nonatomic, strong) UIView *dropdownView;
@property (nonatomic, strong) WebItemView *itemView;

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, copy) NSString *favoId;
@end

@implementation NewsWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.style == WebItemViewStyleNormal ?  [self loadCollectState]:nil;
   
}
- (void)createUI{
    UIView *segeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 87, 32)];
    segeView.layer.cornerRadius = 16;
    segeView.layer.borderWidth = 1;
    segeView.layer.borderColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0, 4, 1, 24)];
    line.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08];
    CGPoint center = line.center;
    center.x = segeView.centerX;
    line.center = center;
    [segeView addSubview:line];
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 32, 32)];
    [share setImage:[UIImage imageNamed:@"web_more"] forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"web_more"] forState:UIControlStateHighlighted];
    [segeView addSubview:share];
    [share addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(46, 0, 32, 32)];
    [close setImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateNormal];
    [close setImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateHighlighted];
    [close addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [segeView addSubview:close];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:segeView];
    self.navigationItem.rightBarButtonItem = item;
    
    
    
}
- (void)loadCollectState{
    NSString *entityId;
    if (self.newsModel) {
        entityId = self.newsModel.newsID;
    }
    if (self.handbookModel) {
        entityId = self.handbookModel.articleId;
    }
    NSDictionary *param = @{@"entityId":entityId};
    [PWNetworking requsetHasTokenWithUrl:PW_favoritesList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
         NSArray *array = response[@"content"][@"data"];
            if (array.count>0) {
                self.isCollect = YES;
                NSDictionary *dict = array[0];
                self.favoId = [dict stringValueForKey:@"id" default:@""];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)shareBtnClick{
    if (self.isCollect == YES) {
        self.style = WebItemViewStyleCollect;
    }else{
        self.style = WebItemViewStyleNormal;
    }
    
     _itemView = [[WebItemView alloc]initWithStyle:self.style];
    [self.itemView showInView:[UIApplication sharedApplication].keyWindow];

    WeakSelf
    self.itemView.itemClick = ^(NSInteger tag){
        
        if(tag == 20 && self.style == WebItemViewStyleNormal){
        NSDictionary *param;
            if (self.newsModel != nil) {
                NSArray *topic = [weakSelf.newsModel.topic componentsSeparatedByString:@" "];
                NSMutableArray *imgs =[NSMutableArray new];
                if (self.newsModel.imageUrl !=nil) {
                    [imgs addObject:weakSelf.newsModel.imageUrl];
                }
                NSString *topstr = topic[topic.count-1];
      param   =@{@"data":@{@"entityId":weakSelf.newsModel.newsID,@"url":weakSelf.newsModel.url,@"title":weakSelf.newsModel.title,@"summary":weakSelf.newsModel.subtitle,@"type":@"forum",@"extras":@{@"imgs":imgs,@"topic":topstr}}};
            }else if(self.handbookModel !=nil){
                NSString *topic = weakSelf.handbookModel.handbookName;
                NSMutableArray *imgs =[NSMutableArray new];
                if (self.handbookModel.imageUrl !=nil) {
                    [imgs addObject:weakSelf.handbookModel.imageUrl];
                }
                 param   =@{@"data":@{@"entityId":weakSelf.handbookModel.articleId,@"url":[weakSelf.webUrl absoluteString],@"title":weakSelf.handbookModel.title,@"summary":weakSelf.handbookModel.summary,@"type":@"handbook",@"extras":@{@"imgs":imgs,@"topic":topic}}};
            }
       
        
        [PWNetworking requsetHasTokenWithUrl:PW_favoritesAdd withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                weakSelf.isCollect = YES;
                [iToast alertWithTitleCenter:@"收藏成功"];
            }
        } failBlock:^(NSError *error) {
            
        }];
    
        }else if(tag == 20 && self.style == WebItemViewStyleCollect){
            [PWNetworking requsetHasTokenWithUrl:PW_favoritesDelete(weakSelf.favoId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
                
                if([response[ERROR_CODE] isEqualToString:@""]){
                    weakSelf.isCollect = NO;
                    weakSelf.favoId = @"";
                    [iToast alertWithTitleCenter:@"取消收藏成功"];
                }else{
                    [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                }
            } failBlock:^(NSError *error) {
              
            }];
            
        }
    };
  
}
- (void)closeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
