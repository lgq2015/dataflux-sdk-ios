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

- (ZhugeIOLibraryHelper *)eventClickBottomTab {
    [self event:@"点击底部Tab"];
    return self;
}

- (ZhugeIOLibraryHelper *)eventLookHandBook {
    [self event:@"查看手册"];
    return self;

}

- (ZhugeIOLibraryHelper *)eventLookHandBookArticle {
    [self event:@"查看手册文章"];
    return self;

}

- (ZhugeIOLibraryHelper *)eventReadHandBookTime {
    [self event:@"阅读手册时长"];
    return self;


}

- (ZhugeIOLibraryHelper *)eventSearchHandBook {
    [self event:@"搜索手册"];
    return self;
}

- (ZhugeIOLibraryHelper *)attrTabName {
    self.data[@"目标位置"] = @"智库";
    return self;
}


- (ZhugeIOLibraryHelper *)attrHandBookName:(NSString *)name {
    self.data[@"手册名"] = name;
    return self;

}

- (ZhugeIOLibraryHelper *)attrArticleName:(NSString *)name {
    self.data[@"文章名称"] = name;
    return self;

}

- (ZhugeIOLibraryHelper *)attrBlongHandBook:(NSString *)name {
    self.data[@"所属手册"] = name;
    return self;

}

- (ZhugeIOLibraryHelper *)attrArticleTitle:(NSString *)name {
    self.data[@"文章标题"] = name;
    return self;

}


- (ZhugeIOLibraryHelper *)attrBlongTopic:(NSString *)name {
    self.data[@"所属 Topic"] = name;
    return self;

}

- (ZhugeIOLibraryHelper *)attrSearchContent:(NSString *)name {
    self.data[@"搜索内容"] = name;
    return self;

}

- (ZhugeIOLibraryHelper *)attrTime:(NSString *)name {
    self.data[@"时长"] = name;
    return self;

}

@end