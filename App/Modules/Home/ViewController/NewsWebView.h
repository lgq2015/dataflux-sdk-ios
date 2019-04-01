//
//  NewsWebView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWBaseWebVC.h"
#import "WebItemView.h"
NS_ASSUME_NONNULL_BEGIN
@class NewsListModel;
@class HandbookModel;

@interface NewsWebView : PWBaseWebVC
@property (nonatomic, strong) NewsListModel *newsModel;
@property (nonatomic, assign) WebItemViewStyle style;
@property (nonatomic, strong) HandbookModel *handbookModel;
@end

NS_ASSUME_NONNULL_END
