//
//  FounctionIntroductionModel.h
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/*
 "app": "Prof.Wang",
 "createTime": "2019-03-22T12:33:18Z",
 "description": "1.哈哈哈哈哈版本\n2.很简单的版本",
 "platform": "IOS",
 "updateTime": "2019-03-22T14:29:29Z",
 "url": "http://pmgmt.jiagouyun.com/repository/mobile-package/android/dev/1.1.0/pw_dev_1.1.0.apk",
 "version": "1.1.1"
 },
 */

@interface FounctionIntroductionModel : JSONModel
@property (nonatomic, strong)NSString *app;
@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSString *platform;
@property (nonatomic, strong)NSString *updateTime;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *version;
@property (nonatomic, assign)NSString<Optional> *isShowMoreButton;
@end

NS_ASSUME_NONNULL_END
