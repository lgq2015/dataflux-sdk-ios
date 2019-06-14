//
//  IssueEngineHeaderView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IssueListViewModel;

@interface IssueEngineHeaderView : UIView
@property (nonatomic, copy) void(^recoverClick)(void);
-(instancetype)initHeaderWithIssueModel:(IssueListViewModel *)model;
-(void)createUIWithDetailDict:(NSDictionary *)dict;
-(void)setContentLabText:(NSString *)text;
-(void)setIssueNameLabText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
