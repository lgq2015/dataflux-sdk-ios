//
//  ItemContentCell.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/4.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "ItemContentCell.h"
#import "GridViewItem.h"
#import "GridViewModel.h"
@implementation ItemContentCell
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    for (int i=0; i<self.dataSource.count; i++) {
        GridViewItem *item = [[GridViewItem alloc]initWithFrame:CGRectMake(ZOOM_SCALE((87.5*(i%4)+10)), ZOOM_SCALE((i/4*109+4)), ZOOM_SCALE(77.5),ZOOM_SCALE(105))];
        NSError *error;
        GridViewModel *model = [[GridViewModel alloc]initWithDictionary:self.dataSource[i] error:&error];
        model.itemIndex = i;
        item.tag = i+10;
        item.model = model;
        item.itemClick = ^(NSInteger index){
            
        };
        [[self viewWithTag:i+10] removeFromSuperview];
        [self addSubview:item];
    }
}
@end
