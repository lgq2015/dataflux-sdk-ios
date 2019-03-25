//
//  CreateQuestionModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateQuestionModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *fileID;
@end

NS_ASSUME_NONNULL_END
