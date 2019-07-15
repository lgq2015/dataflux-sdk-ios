//
//  MultipleSelectModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultipleSelectModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *selectId;
@property (nonatomic, assign) BOOL allSelect;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
