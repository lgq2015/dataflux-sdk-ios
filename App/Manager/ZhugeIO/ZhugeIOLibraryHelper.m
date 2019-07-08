//
// Created by Brandon on 2019-07-08.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOLibraryHelper.h"


@implementation ZhugeIOLibraryHelper {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"智库";
    }
    return self;
}

- (void)eventClickBottomTab {
    [self event:@"点击底部Tab"];
}

- (void)eventLookHandBook {
    [self event:@"查看手册"];
}

- (void)eventLookHandBookArticle {
    [self event:@"查看手册文章"];
}

- (void)eventReadHandBookTime {
    [self event:@"阅读手册时长"];
}

- (void)eventSearchHandBook {
    [self event:@"搜索手册"];
}

- (void)attrTabName {
    self.data[@"目标位置"] = @"智库";
}


- (void)attrHandBookName:(NSString *)name {
    self.data[@"手册名"] = name;
}

- (void)attrArticleName:(NSString *)name {
    self.data[@"文章名称"] = name;
}

- (void)attrBlongHandBook:(NSString *)name {
    self.data[@"所属手册"] = name;
}

- (void)attrArticleTitle:(NSString *)name {
    self.data[@"文章标题"] = name;
}


- (void)attrBlongTopic:(NSString *)name {
    self.data[@"所属 Topic"] = name;
}

- (void)attrSearchContent:(NSString *)name {
    self.data[@"搜索内容"] = name;
}

- (void)attrTime:(NSString *)name {
    self.data[@"时长"] = name;
}

@end