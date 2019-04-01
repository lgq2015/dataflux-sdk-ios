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
-(instancetype)initWithTitle:(NSString *)title{
   return  [self initWithTitle:title icon:@"" cellType:100];
}
-(instancetype)initWithTitle:(NSString *)title isSwitch:(BOOL)isOn{
    if (self = [super init]) {
        self.title = title;
        self.isOn = isOn;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title describeText:(NSString *)text{
    if (self = [super init]) {
        self.title = title;
        self.describeText = text;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon{
    if (self = [super init]) {
        self.title = title;
        self.rightIcon = rightIcon;
    }
    return self;
}
@end
