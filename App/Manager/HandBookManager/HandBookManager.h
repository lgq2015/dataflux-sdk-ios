//
// Created by Brandon on 2019-03-25.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSqlHelper.h"

@class LibraryModel;


@interface HandBookManager : BaseSqlHelper
+ (instancetype)sharedInstance;

- (void)cacheHandBooks:(NSArray *)datas;

- (NSMutableArray<LibraryModel*> *)getHandBooks;
@end