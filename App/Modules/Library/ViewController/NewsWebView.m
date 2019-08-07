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
#import "ZYSocialManager.h"
#import "ZhugeIOLibraryHelper.h"
#import "ZhugeIOIssueHelper.h"

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

    if (self.fromvc == FromVCHandBookArticle || self.fromvc == FromVCHandBookIndex) {
        if (self.handbookModel) {
            [[[[[ZhugeIOLibraryHelper new] eventLookHandBookArticle]
                    attrArticleTitle:self.handbookModel.title]
                    attrBlongTopic:self.handbookModel.handbookName] track];

            [[[ZhugeIOLibraryHelper new] eventReadHandBookTime] startTrack];
        }
    }
   
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
        self.style = WebItemViewStyleCollected;
    }else{
        if (self.style !=WebItemViewStyleNoCollect) {
            self.style = WebItemViewStyleNormal;
        }
    }
    
     _itemView = [[WebItemView alloc]initWithStyle:self.style];
    [self.itemView showInView:[UIApplication sharedApplication].keyWindow];

    WeakSelf
    self.itemView.itemClick = ^(NSInteger tag){
        
        if(tag == CollectionBtnTag && self.style == WebItemViewStyleNormal){
        NSDictionary *param;
            if (self.newsModel != nil) {
                NSArray *topic = [weakSelf.newsModel.topic componentsSeparatedByString:@" "];
                NSMutableArray *imgs =[NSMutableArray new];
                if (self.newsModel.imageUrl.length>0) {
                    [imgs addObject:weakSelf.newsModel.imageUrl];
                }
                NSString *topstr = topic[topic.count-1];
                NSDictionary *extras = imgs.count>0?@{@"imgs":imgs,@"topic":topstr}:@{@"topic":topstr};
      param   =@{@"data":@{@"entityId":weakSelf.newsModel.newsID,@"url":weakSelf.newsModel.url,@"title":weakSelf.newsModel.title,@"summary":weakSelf.newsModel.subtitle,@"type":@"forum",@"extras":extras}};
            }else if(self.handbookModel !=nil){
                NSString *topic = weakSelf.handbookModel.handbookName;
                NSMutableArray *imgs =[NSMutableArray new];
                if (self.handbookModel.imageUrl.length>0) {
                    [imgs addObject:weakSelf.handbookModel.imageUrl];
                }
                NSDictionary *extras = nil;
                if (self.fromvc == FromVCHandBookIndex){//从速查表进来，不传图片
                    extras = @{@"topic":topic};
                }else{
                    extras = imgs.count>0?@{@"imgs":imgs,@"topic":topic}:@{@"topic":topic};
                }
                 param   =@{@"data":@{@"entityId":weakSelf.handbookModel.articleId,@"url":[weakSelf.webUrl absoluteString],@"title":weakSelf.handbookModel.title,@"summary":weakSelf.handbookModel.summary,@"type":@"handbook",@"extras":extras}};
            }
       
        
        [PWNetworking requsetHasTokenWithUrl:PW_favoritesAdd withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                weakSelf.isCollect = YES;
                weakSelf.favoId = response[@"content"][@"id"];
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.tip.CollectionSuccess", @"")];

                if (weakSelf.handbookModel) {
                    [[[[[ZhugeIOLibraryHelper new] eventCollectionHandBookArticle]
                            attrArticleTitle:weakSelf.handbookModel.title] attrBlongTopic:weakSelf.handbookModel.handbookName] track];
                }


            }
        } failBlock:^(NSError *error) {
            
        }];
    
        }else if(tag == CollectionBtnTag && self.style == WebItemViewStyleCollected){
            [weakSelf controlClickTimes];
            [PWNetworking requsetHasTokenWithUrl:PW_favoritesDelete(weakSelf.favoId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
                if([response[ERROR_CODE] isEqualToString:@""]){
                    weakSelf.isCollect = NO;
                    weakSelf.favoId = @"";
                    [iToast alertWithTitleCenter:NSLocalizedString(@"local.tip.CancelCollectionSuccess", @"")];
                }else{
                    [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                }
            } failBlock:^(NSError *error) {
              
            }];
            
        }else if(tag == ShareBtnTag){
            [weakSelf popShareUI];
        }
    };
  
}
- (void)closeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---分享---
- (void)popShareUI{
    __weak typeof(self) weakself = self;
    [[ZYSocialUIManager shareInstance] showWithPlatformSelectionBlock:^(SharePlatformType sharePlatformType) {
        NSString *title = !weakself.newsModel ? weakself.handbookModel.title : weakself.newsModel.title;
        NSString *descr = !weakself.newsModel ? weakself.handbookModel.summary : @"";
        NSString *url = !weakself.newsModel ? weakself.handbookModel.htmlPath : weakself.newsModel.url;
        ZYSocialManager *manager = [[ZYSocialManager alloc]initWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"144-144"]];
        manager.webpageUrl = url;
        manager.showVC = weakself;
        [manager shareToPlatform:sharePlatformType viewController:self];
    }];
}
#pragma mark --避免按钮点击多次----
- (void)controlClickTimes{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void)dealloc {

    [[[[[[ZhugeIOLibraryHelper new] eventReadHandBookTime]
            attrArticleTitle:self.handbookModel.title]
            attrBlongTopic:self.handbookModel.handbookName] attrTime] endTrack];
}


@end

