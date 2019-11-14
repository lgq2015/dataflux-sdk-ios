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
@property (nonatomic, copy) void(^recoverClick)(void);
@property (nonatomic, copy) void(^assignClick)(BOOL needNavSel);

-(instancetype)initHeaderWithIssueModel:(IssueListViewModel *)model;
-(void)setCreateUserName:(NSString *)name;
-(void)reloadHeaderUI;
-(void)createAttachmentUIWithAry:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
