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


-(ZhugeIOBaseEventHelper *) eventChangTopTab{
    return [self event:@"切换顶部Tab"];
}

-(ZhugeIOBaseEventHelper *) eventQuickConfigIssueSource{
    return [self event:@"立即配置情报源"];
}


-(ZhugeIOBaseEventHelper *) eventClickBottomTab{
    return [self event:@"点击底部Tab"];
}


-(ZhugeIOBaseEventHelper *) eventClickRecommend{
    return [self event:@"点击推荐位"];
}

-(ZhugeIOBaseEventHelper *) eventLookRecommendArticle{
    return [self event:@"查看推荐位文章"];
}


-(ZhugeIOBaseEventHelper *) eventReadArticleTime{
    return [self event:@"阅读文章时长"];
}

-(ZhugeIOBaseEventHelper *) eventClickScan{
    return [self event:@"点击扫一扫"];
}

-(ZhugeIOBaseEventHelper *) eventClickTool{
    return [self event:@"点击工具"];
}


-(ZhugeIOBaseEventHelper *) eventClickToolBox{
    return [self event:@"点击工具箱"];
}

-(ZhugeIOBaseEventHelper *) eventConfigIssueSource{
    return [self event:@"配置情报源"];
}


-(ZhugeIOBaseEventHelper *) eventClickIssueClass{
    return [self event:@"点击情报类别"];
}


-(ZhugeIOBaseEventHelper *) eventLookHandBook{
    return [self event:@"阅读手册时长"];
}

-(ZhugeIOBaseEventHelper *) eventSearchHandBook{
    return [self event:@"搜索手册"];
}

-(ZhugeIOBaseEventHelper *) eventShareArticle{
    return [self event:@"分享文章"];
}

-(ZhugeIOBaseEventHelper *) eventShareHandBookArticle{
    return [self event:@"分享手册文章"];
}

-(ZhugeIOBaseEventHelper *) eventCollectionArticle{
    return [self event:@"收藏文章"];
}


-(ZhugeIOBaseEventHelper *) eventCollectionHandBookArticle{
    return [self event:@"收藏手册文章"];
}

-(ZhugeIOBaseEventHelper *) eventLookIssue{
    return [self event:@"查看情报"];
}

-(ZhugeIOBaseEventHelper *) eventIssueLookTime{
    return [self event:@"情报查看时长"];
}


-(ZhugeIOBaseEventHelper *) eventCreateProblem{
    return [self event:@"创建问题"];
}

-(ZhugeIOBaseEventHelper *) eventLookIssusProgress{
    return [self event:@"查看情报进展"];
}


-(ZhugeIOBaseEventHelper *) eventClickExpertSuggest{
    return [self event:@"点击专家建议"];
}

-(ZhugeIOBaseEventHelper *) eventLookSuggestAtticle{
    return [self event:@"查看建议文章"];
}


-(ZhugeIOBaseEventHelper *) eventJoinDiscuss{
    return [self event:@"进入讨论"];
}


-(ZhugeIOBaseEventHelper *) eventDiscussAreaTime{
    return [self event:@"讨论区停留时长"];
}

-(ZhugeIOBaseEventHelper *) eventDiscussAreaSay{
    return [self event:@"讨论区发言"];
}


-(ZhugeIOBaseEventHelper *) eventClickLookDiscussMember{
    return [self event:@"点击查看讨论成员"];
}

-(ZhugeIOBaseEventHelper *) eventCallExpert{
    return [self event:@"拨打专家电话"];
}


-(ZhugeIOBaseEventHelper *) eventFindExpertHelp{
    return [self event:@"寻求专家协助"];
}

-(ZhugeIOBaseEventHelper *) eventQuickInviteExpert{
    return [self event:@"立即邀请专家"];
}

-(ZhugeIOBaseEventHelper *) eventCloseProblem{
    return [self event:@"关闭问题"];
}


-(ZhugeIOBaseEventHelper *) eventLookIssueSource{
    return [self event:@"查看情报源"];
}

-(ZhugeIOBaseEventHelper *) eventDeleteIssueSource{
    return [self event:@"删除情报源"];
}


-(ZhugeIOBaseEventHelper *) eventEditIssueSource{
    return [self event:@"编辑情报源"];
}

-(ZhugeIOBaseEventHelper *) eventAddIssueSource{
    return [self event:@"添加情报源"];
}

-(ZhugeIOBaseEventHelper *) eventAddIssusSourceStayTime{
    return [self event:@"添加情报源"];
}







@end