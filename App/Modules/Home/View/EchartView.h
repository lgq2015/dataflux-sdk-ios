//
//  EchartView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS-Echarts.h"

NS_ASSUME_NONNULL_BEGIN

@interface EchartView : UIView
@property (nonatomic, strong) WKEchartsView *kEchartView;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict smooth:(BOOL)smooth;
- (instancetype)initWithDayPieDict:(NSDictionary *)dict;
- (void)refreshEchartsWithNewData:(NSDictionary *)data smooth:(BOOL)smooth;
@end

NS_ASSUME_NONNULL_END
