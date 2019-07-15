//
//  NotiRuleListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NotiRuleListModel.h"
#import "NotiRuleModel.h"
@implementation NotiRuleListModel
- (id)getItemData:(NSDictionary *)dic {
    NSError *error;
    NotiRuleModel *model = [[NotiRuleModel alloc]initWithDictionary:dic error:&error];
    CGSize titleFrame = [model.name strSizeWithMaxWidth:ZOOM_SCALE(202) withFont:RegularFONT(18)];
    model.titleHeight = titleFrame.height>ZOOM_SCALE(23)?titleFrame.height:ZOOM_SCALE(23);
    model.cellHeight = ZOOM_SCALE(453)+12;
    model.cellHeight = model.cellHeight+model.titleHeight-ZOOM_SCALE(23);
    if ([model.rule.tags allKeys].count == 0) {
        model.cellHeight-=ZOOM_SCALE(31);
    }
    return model;
}
@end
