//
//  InformationSourceCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueSourceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InformationSourceCell : UITableViewCell
@property (nonatomic, strong) IssueSourceViewModel *model;
@end

NS_ASSUME_NONNULL_END
