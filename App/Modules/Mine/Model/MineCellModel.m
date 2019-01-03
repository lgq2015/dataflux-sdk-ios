//
//  MineCellModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MineCellModel.h"

@implementation MineCellModel
-(instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon cellType:(MineCellType)type{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.type = type;
    }
    return self;
}
@end
