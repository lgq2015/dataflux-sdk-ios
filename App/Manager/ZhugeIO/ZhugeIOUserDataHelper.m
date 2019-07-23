//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Zhugeio/Zhuge.h>
#import "ZhugeIOUserDataHelper.h"
#import "CurrentUserModel.h"


@implementation ZhugeIOUserDataHelper {

}


- (void)bindUserData:(CurrentUserModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"姓名"] = model.name;
    dic[@"手机号"] = model.mobile;
    [[Zhuge sharedInstance] identify:model.userID properties:dic];
}
@end