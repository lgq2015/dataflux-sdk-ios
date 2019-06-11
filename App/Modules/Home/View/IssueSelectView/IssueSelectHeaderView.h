//
//  IssueSelectView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueSelectView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol IssueSelectHeaderDelegate <NSObject>

-(void)selectIssueSelectObject:(SelectObject *)sel;
@end
@interface IssueSelectHeaderView : UIView
@property (nonatomic, strong) IssueSelectView *selView;
@property(nonatomic,assign)id<IssueSelectHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
