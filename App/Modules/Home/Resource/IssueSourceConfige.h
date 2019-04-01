//
//  IssueSourceConfige.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueSourceViewModel.h"
#import "IssueTf.h"

@interface IssueSourceConfige : NSObject
@property (nonatomic, strong) NSString *subTip;
@property (nonatomic, strong) NSString *topTip;
@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic, strong) NSString *deletAlert;
@property (nonatomic, strong) NSString *vcProvider;
@property (nonatomic, strong) NSString *yunTitle;
@property (nonatomic, strong) NSString *helpUrl;
@property (nonatomic, strong) NSMutableArray<IssueTf*> *issueTfArray;
-(instancetype)initWithType:(SourceType)type;
@end

