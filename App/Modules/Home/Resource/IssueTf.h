//
//  IssueTf.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueTf : NSObject

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *tfTitle;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
