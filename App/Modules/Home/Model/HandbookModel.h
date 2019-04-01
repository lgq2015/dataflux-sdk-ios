//
//  HandbookModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
/*
 articleId = "hdbk-bfX4g6YqcExwTRntW6WysW";
 createTime = "2019-02-15T09:13:22Z";
 firstChar = a;
 handbookCategory = handbook;
 handbookId = "hdbk-tz6RomJC728WDUy7JbvP59";
 handbookName = "\U6797\U7eb3\U514b\U65af\U547d\U4ee4\U96c6";
 htmlPath = "http://diaobao-test.oss-cn-hangzhou.aliyuncs.com/handbooktest_html/linux-cmd/adduser/index.html";
 imageUrl = "";
 lastModified = "2018-10-19T05:45:24Z";
 mdPath = "handbooktest/linux-cmd/adduser/index.md";
 readingCount = 550;
 summary = "adduser\U529f\U80fd\U4f7f\U7528\U6743\U9650\Uff1a\U7cfb\U7edf\U7ba1\U7406\U5458adduser\U6216useradd \U547d\U4ee4\U7528\U4e8e\U65b0\U589e\U4f7f\U7528\U8005\U5e10\U53f7\U6216\U66f4\U65b0\U9884\U8bbe\U7684\U4f7f\U7528\U8005\U8d44\U6599\U3002\U8bed\U6cd5adduser[-c comment][-d home_dir][-e expire_date][-f inactive_time][-g initial_group][-G group[,...]][-m[-k skeleton_dir]";
 title = adduser;
 updateTime = "2019-02-15T09:13:22Z";
 */
NS_ASSUME_NONNULL_BEGIN

@interface HandbookModel : JSONModel
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *firstChar;
@property (nonatomic, strong) NSString *handbookCategory;
@property (nonatomic, strong) NSString *handbookName;
@property (nonatomic, strong) NSString *handbookId;
@property (nonatomic, strong) NSString *htmlPath;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
