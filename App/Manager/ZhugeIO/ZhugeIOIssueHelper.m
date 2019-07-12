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


- (ZhugeIOIssueHelper *)eventClickBottomTab {
    [self event:@"点击底部Tab"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickScan {
    [self event:@"点击扫一扫"];
    return self;

}


- (ZhugeIOIssueHelper *)eventClickIssueClass {
    [self event:@"点击情报类别"];
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


- (ZhugeIOIssueHelper *)eventCloseProblem {
    [self event:@"关闭问题"];
    return self;

}


- (ZhugeIOIssueHelper *)eventSwitchTeam {
    [self event:@"点击切换团队"];
    return self;
}


- (ZhugeIOIssueHelper *)attrTabName {
    self.data[@"目标位置"] = @"情报";
    return self;
}


- (ZhugeIOIssueHelper *)attrTime {
    self.data[@"时长"] = @"秒";
    return self;

}

- (ZhugeIOIssueHelper *)attrIssueTitle:(NSString *)name {
    self.data[@"情报标题"] = name;
    return self;

}

- (ZhugeIOIssueHelper *)attrIssueType:(NSString *)type {
    self.data[@"情报分类"] = type;
    return self;

}

- (ZhugeIOIssueHelper *)attrIssueLevel:(NSString* )level {
    self.data[@"严重级别"] = level;
    return self;

}

- (ZhugeIOIssueHelper *)attrAddEnclosure:(BOOL)isAttach {
    self.data[@"严重级别"] = isAttach ? @"是" : @"否";
    return self;

}

- (ZhugeIOIssueHelper *)attrContentWords {
    self.data[@"内容类型"] = @"文字";
    return self;

}

- (ZhugeIOIssueHelper *)attrContentImage {
    self.data[@"内容类型"] = @"图片";
    return self;

}

- (ZhugeIOIssueHelper *)attrMemberOrdinary {
    self.data[@"成员类型"] = @"团队成员";
    return self;

}

- (ZhugeIOIssueHelper *)attrMemberExpert {
    self.data[@"成员类型"] = @"专家";
    return self;

}

- (ZhugeIOIssueHelper *)attrCallPhone:(BOOL)call {
    self.data[@"是否拨打"] = call ? @"确认" : @"取消";
    return self;
}


@end