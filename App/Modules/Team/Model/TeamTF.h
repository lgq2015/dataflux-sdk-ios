//
//  TeamTF.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeamTF : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL showArrow;
@end

NS_ASSUME_NONNULL_END
