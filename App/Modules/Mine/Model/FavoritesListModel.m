//
//  FavoritesListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/8/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FavoritesListModel.h"
#import "NewsListModel.h"
@implementation FavoritesListModel
- (id)getItemData:(NSDictionary *)dic {
    return [[NewsListModel alloc] initWithCollectionDictionary:dic];
}
@end
