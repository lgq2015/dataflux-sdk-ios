//
// Created by Brandon on 2019-07-08.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhugeIOBaseEventHelper.h"


@interface ZhugeIOLibraryHelper : ZhugeIOBaseEventHelper
- (ZhugeIOLibraryHelper *)eventClickBottomTab;

- (ZhugeIOLibraryHelper *)attrTabName;

- (ZhugeIOLibraryHelper *)eventLookHandBook;

- (ZhugeIOLibraryHelper *)eventLookHandBookArticle;

- (ZhugeIOLibraryHelper *)eventReadHandBookTime;

- (ZhugeIOLibraryHelper *)eventSearchHandBook;

- (ZhugeIOLibraryHelper *)attrHandBookName:(NSString *)name;

- (ZhugeIOLibraryHelper *)attrArticleName:(NSString *)name;

- (ZhugeIOLibraryHelper *)attrBlongHandBook:(NSString *)name;

- (ZhugeIOLibraryHelper *)attrArticleTitle:(NSString *)name;

- (ZhugeIOLibraryHelper *)attrBlongTopic:(NSString *)name;

- (ZhugeIOLibraryHelper *)eventCollectionHandBookArticle;

- (ZhugeIOLibraryHelper *)attrSearchContent:(NSString *)name;

- (ZhugeIOLibraryHelper *)attrTime;
@end