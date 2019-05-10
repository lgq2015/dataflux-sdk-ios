//
//  AtReadSeqAndAccountID.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AtReadSeqAndAccountID : NSObject
@property (nonatomic, assign) long long seq;
@property (nonatomic, strong) NSString *accountId;
@end

NS_ASSUME_NONNULL_END
