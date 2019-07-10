//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOIssueHelper.h"


@implementation ZhugeIOIssueHelper {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"首页";
    }
    return self;
}


- (ZhugeIOIssueHelper *)eventChangTopTab {
    [self event:@"切换顶部Tab"];
    return self;
}

- (ZhugeIOIssueHelper *)eventQuickConfigIssueSource {
    [self event:@"立即配置情报源"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickBottomTab {
    [self event:@"点击底部Tab"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickRecommend {
    [self event:@"点击推荐位"];
    return self;

}

- (ZhugeIOIssueHelper *)eventLookRecommendArticle {
    [self event:@"查看推荐位文章"];
    return self;

}


- (ZhugeIOIssueHelper *)eventReadArticleTime {
    [self event:@"阅读文章时长"];
    return self;

}

- (ZhugeIOIssueHelper *)eventClickScan {
    [self event:@"点击扫一扫"];
    return self;

}

- (ZhugeIOIssueHelper *)eventClickTool {
    [self event:@"点击工具"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickToolBox {
    [self event:@"点击工具箱"];
    return self;

}

- (ZhugeIOIssueHelper *)eventConfigIssueSource {
    [self event:@"配置情报源"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickIssueClass {
    [self event:@"点击情报类别"];
    return self;

}


- (ZhugeIOIssueHelper *)eventLookHandBook {
    [self event:@"阅读手册时长"];
    return self;

}

- (ZhugeIOIssueHelper *)eventSearchHandBook {
    [self event:@"搜索手册"];
    return self;

}

- (ZhugeIOIssueHelper *)eventShareArticle {
    [self event:@"分享文章"];
    return self;

}

- (ZhugeIOIssueHelper *)eventShareHandBookArticle {
    [self event:@"分享手册文章"];
    return self;

}

- (ZhugeIOIssueHelper *)eventCollectionArticle {
    [self event:@"收藏文章"];
    return self;
}


- (ZhugeIOIssueHelper *)eventCollectionHandBookArticle {
    [self event:@"收藏手册文章"];
    return self;

}

- (ZhugeIOIssueHelper *)eventLookIssue {
    [self event:@"查看情报"];
    return self;

}

- (ZhugeIOIssueHelper *)eventIssueLookTime {
    [self event:@"情报查看时长"];
    return self;

}


- (ZhugeIOIssueHelper *)eventCreateProblem {
    [self event:@"创建问题"];
    return self;

}

- (ZhugeIOIssueHelper *)eventLookIssusProgress {
    [self event:@"查看情报进展"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickExpertSuggest {
    [self event:@"点击专家建议"];
    return self;

}

- (ZhugeIOIssueHelper *)eventLookSuggestAtticle {
    [self event:@"查看建议文章"];
    return self;

}


- (ZhugeIOIssueHelper *)eventJoinDiscuss {
    [self event:@"进入讨论"];
    return self;

}


- (ZhugeIOIssueHelper *)eventDiscussAreaTime {
    [self event:@"讨论区停留时长"];
    return self;

}

- (ZhugeIOIssueHelper *)eventDiscussAreaSay {
    [self event:@"讨论区发言"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickLookDiscussMember {
    [self event:@"点击查看讨论成员"];
    return self;

}

- (ZhugeIOIssueHelper *)eventCallExpert {
    [self event:@"拨打专家电话"];
    return self;

}


- (ZhugeIOIssueHelper *)eventFindExpertHelp {
    [self event:@"寻求专家协助"];
    return self;

}

- (ZhugeIOIssueHelper *)eventQuickInviteExpert {
    [self event:@"立即邀请专家"];
    return self;

}

- (ZhugeIOIssueHelper *)eventCloseProblem {
    [self event:@"关闭问题"];
    return self;

}


- (ZhugeIOIssueHelper *)eventLookIssueSource {
    [self event:@"查看情报源"];
    return self;

}

- (ZhugeIOIssueHelper *)eventDeleteIssueSource {
    [self event:@"删除情报源"];
    return self;

}


- (ZhugeIOIssueHelper *)eventEditIssueSource {
    [self event:@"编辑情报源"];
    return self;

}

- (ZhugeIOIssueHelper *)eventAddIssueSource {
    [self event:@"添加情报源"];
    return self;

}

- (ZhugeIOIssueHelper *)eventAddIssusSourceStayTime {
    [self event:@"添加情报源"];
    return self;

}


@end