//
//  SelectObject.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueListManger.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectObject : NSObject<NSCoding>
@property(nonatomic, assign) IssueLevel issueLevel;
@property(nonatomic, assign) IssueSortType issueSortType;
@property(nonatomic, assign) IssueViewType issueViewType;
@property(nonatomic, assign) IssueType issueType;
@end

NS_ASSUME_NONNULL_END
