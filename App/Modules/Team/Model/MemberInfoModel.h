//
//  MemberInfoModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/*{
    email = "wupeng@jiagouyun.com";
    id = "acnt-fpZmaX4JYtS3u7xxywVuAB";
    isAdmin = 1;
    isDefault = 1;
    isDisabled = 0;
    mobile = 12312312312;
    name = wupeng;
    namespace = default;
    outerIdentifier = "<null>";
    outerIdentifierType = "<null>";
    tags =             {
        pwAvatar = "http://diaobao-test.oss-cn-hangzhou.aliyuncs.com/account_file/acnt-fpZmaX4JYtS3u7xxywVuAB/pwAvatar/d5483c24-11c7-4556-a267-86b4ae7aaad9unknow";
    };
    username = wupeng;
}
*/
@interface MemberInfoModel : JSONModel
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *tags;
@property (nonatomic, copy)NSString *inTeamNote;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) NSString *outerIdentifier;
@property (nonatomic, strong) NSString *outerIdentifierType;
//是否是专家
@property (nonatomic, assign) BOOL isSpecialist;
@end

NS_ASSUME_NONNULL_END
