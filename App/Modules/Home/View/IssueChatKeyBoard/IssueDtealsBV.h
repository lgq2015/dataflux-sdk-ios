//
//  IssueDtealsBV.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IssueDtealsBVDelegate <NSObject>
- (void)issueDtealsBVClick;
@end
NS_ASSUME_NONNULL_BEGIN

@interface IssueDtealsBV : UIView
@property (nonatomic, assign) id<IssueDtealsBVDelegate> delegate;
@property (nonatomic, copy) NSString *oldStr;
@end

NS_ASSUME_NONNULL_END
