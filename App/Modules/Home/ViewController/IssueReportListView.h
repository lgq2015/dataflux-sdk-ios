//
//  IssueReportListView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/11/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef  NS_ENUM(NSInteger, ReportListType){
  ReportListTypeDaily = 1,
  ReportListTypeWebSecurity,
  ReportListTypeService,
};
NS_ASSUME_NONNULL_BEGIN

@interface IssueReportListView : RootViewController
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) ReportListType type;
@end

NS_ASSUME_NONNULL_END
