//
//  PWDraggableModel.h
//  PWDraggableLibraryView
//
//  Created by 胡蕾蕾 on 2018/9/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWDraggableModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary;
@end
