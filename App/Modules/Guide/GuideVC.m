//
//  GuideVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *guideCollection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
}
- (UICollectionView *)guideCollection{
    if (!_guideCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(kWidth, kHeight);
        layout.minimumLineSpacing = 0;
        _guideCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _guideCollection.delegate = self;
        _guideCollection.dataSource = self;
        _guideCollection.scrollEnabled = NO;
        _guideCollection.backgroundColor = PWBackgroundColor;
       
        [self.view addSubview:_guideCollection];
        
    }
    return _guideCollection;
}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return  self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
