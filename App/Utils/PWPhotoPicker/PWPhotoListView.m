//
//  PWPhotoListView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWPhotoListView.h"
#import "PWPhotoListCell.h"
@implementation PWPhotoListView
#pragma mark - init
- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [[PWPhotoListView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    if (self) {
        [self registerClass:[PWPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
