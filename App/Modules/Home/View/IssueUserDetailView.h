//
//  IssueUserDetailView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IssueListViewModel;

@interface IssueUserDetailView : UIView
-(instancetype)initHeaderWithIssueModel:(IssueListViewModel *)model;
-(void)createAttachmentUIWithAry:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END