//
//  IssueSourceView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueSourceConfige.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueSourceView : UIView
@property (nonatomic, strong) NSMutableArray<UITextField *> *TFArray;

- (instancetype)initWithShowInControllerView:(UIViewController *)controller withIssueConfig:(IssueSourceConfige*)config;

@end

NS_ASSUME_NONNULL_END
