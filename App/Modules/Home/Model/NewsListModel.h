//
//  NewsListModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
typedef NS_ENUM(NSUInteger, NewListCellType) {
    NewListCellTypeSingleImg  = 0,
    NewListCellTypText,
    NewListCellTypeFillImg
};

@interface NewsListModel : JSONModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL showFlag;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger type;

@end

