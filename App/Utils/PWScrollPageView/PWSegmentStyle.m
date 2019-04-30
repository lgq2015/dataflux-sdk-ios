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
        self.scrollLineColor = self.selectedTitleColor = PWBlueColor;
     
        self.titleMargin = 15.0;
        self.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        self.selectTitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        self.normalTitleColor =RGBACOLOR(201, 201, 201, 1);
        
        self.selectedTitleColor =RGBACOLOR(255, 78, 0, 1);
        self.showExtraButton = NO;
        self.segmentHeight = kStatusBarHeight+60;
        self.extraBtnImageNames = nil;
    }
    return self;
}
@end
