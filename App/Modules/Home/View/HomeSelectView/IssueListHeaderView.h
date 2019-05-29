//
//  IssueListHeaderView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IssueListHeaderDelegate <NSObject>

-(void)selectIssueTypeIndex:(NSInteger)index;
-(void)selectIssueViewTypeIndex:(NSInteger)index;

@end
NS_ASSUME_NONNULL_BEGIN

@interface IssueListHeaderView : UIView
@property(nonatomic,assign)id<IssueListHeaderDelegate> delegate;
-(void)refreshHeaderViewTitle;
@end

NS_ASSUME_NONNULL_END
