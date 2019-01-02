//
//  PWSegmentStyle.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import "PWSegmentStyle.h"

@implementation PWSegmentStyle

- (instancetype)init {
    if(self = [super init]) {
       
        self.scrollLineHeight = 4;
        self.scrollLineColor = self.selectedTitleColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0/255.0 alpha:1.0];
     
        self.titleMargin = 15.0;
        self.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        self.selectTitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        self.normalTitleColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        
        self.selectedTitleColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:0/255.0 alpha:1.0];
        self.showExtraButton = NO;
        self.extraBtnFrame = CGRectZero;
        self.segmentHeight = kStatusBarHeight+60;
        self.extraBtnImageNames = nil;
    }
    return self;
}
@end
