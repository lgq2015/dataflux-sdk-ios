//
//  TeamHeaderView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#define InvateTag 15
#define InfoSourceTag 16
#define ServeTag 17
#define TeamManageTag 18
NS_ASSUME_NONNULL_BEGIN

@interface TeamHeaderView : UIView
@property (nonatomic, copy) void(^itemClick)(NSInteger index);

-(void)setTeamName:(NSString *)teamName;
@end

NS_ASSUME_NONNULL_END
