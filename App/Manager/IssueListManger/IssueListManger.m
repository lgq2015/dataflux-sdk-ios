//
//  IssueListManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueListManger.h"
typedef void (^pageBlock) (NSString * pageMarker);
@interface IssueListManger()
@end
@implementation IssueListManger
SINGLETON_FOR_CLASS(IssueListManger);
- (BOOL)isNeedUpdateAll{
    
    return YES;
}
- (void)downLoadAllIssueList{
    NSDictionary *params = @{@"_withLatestIssueLog":@YES,@"orderBy":@"seq",@"_latestIssueLogLimit":@1};
    [self loadIssueListWithParam:params nextPage:^(NSString *pageMarker) {
        
    }];
    
}
- (void)insertIssue{
    
}

- (void)loadIssueListWithParam:(NSDictionary *)param nextPage:(pageBlock)page{
    [PWNetworking requsetHasTokenWithUrl:PW_issueList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            NSDictionary *pageInfo = response[@"pageInfo"];
        }else{
            
        }
    } failBlock:^(NSError *error) {
        
    }];
}
@end
