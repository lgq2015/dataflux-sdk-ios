//
//  MonitorListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MonitorListModel.h"
#import "IssueModel.h"
@implementation MonitorListModel
- (instancetype)initWithJsonDictionary:(IssueModel *)model{
    if (![model isKindOfClass:[IssueModel class]]) return nil;
    if (self = [super init]) {
        [self setValueWithModel:model];
    }
    return self;
}
- (void)setValueWithModel:(IssueModel *)model{
    if ([model.level isEqualToString:@"danger"]) {
        self.state = MonitorListStateSeriousness;
    }else if([model.level isEqualToString:@"warning"]){
        self.state = MonitorListStateWarning;
    }else{
        self.state =MonitorListStateCommon;
    }
    if ([model.status isEqualToString:@"recovered"]) {
        self.state =MonitorListStateRecommend;
    }else if ([model.status isEqualToString:@"expired"] || [model.status isEqualToString:@"discarded"]){
        self.state = MonitorListStateLoseeEfficacy;
    }
    if (![model.renderedTextStr isEqualToString:@""]) {
        NSDictionary *dict = [NSString dictionaryWithJsonString:model.renderedTextStr];
        self.title = dict[@"title"];
        self.content = dict[@"summary"];
        self.attrs = dict[@"suggestion"];
        self.highlight = dict[@"highlight"];
    }else{
        self.title = model.title;
        self.content = model.content;
        self.attrs = model.latestIssueLogs[0][@"title"];
    }
    self.time = model.updateTime;
    if ([model.origin isEqualToString:@"user"]) {
        self.isFromUser = YES;
    }else{
        self.isFromUser = NO;
    }
}
@end
