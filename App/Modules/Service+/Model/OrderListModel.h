//
//  OrderListModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 commodityNames = "\U4e91\U8ba1\U7b97\U8bca\U65ad\Uff0810\Uff09";
 commodityPackageName = "CloudCare \U4e91\U8ba1\U7b97\U8bca\U65ad-\U6807\U51c6\U7248";
 contractNo = 5c836a4a1d3bb60006014b26;
 createTime = "2019-03-09T07:24:58Z";
 discountRate = "100.00%";
 id = 5c836a4a1d3bb60006014b27;
 operator = "\U59d3\U540d123456000001";
 orderTimeRemarks =                 (
 );
 price = 5000;
 remark = "<null>";
 status = Enabled;
 teamName = "12345600000\U56e2\U961f";
 totalPayment = 5000;
 updateTime = "2019-03-09T07:25:07Z";
 */
@interface OrderListModel : JSONModel
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *commodityPackageName;

@end

NS_ASSUME_NONNULL_END
