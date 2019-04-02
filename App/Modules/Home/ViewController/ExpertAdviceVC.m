//
//  ExpertAdviceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ExpertAdviceVC.h"

@interface ExpertAdviceVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ExpertAdviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家建议";
    [self createUI];
    // Do any additional setup after loading the view.
}
#pragma mark ========== UI ==========
- (void)createUI{
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, kWidth, ZOOM_SCALE(22))];
    tip.text = @"邀请专家加入到您的讨论中";
    tip.font =  RegularFONT(16);
    tip.textColor = PWTitleColor;
    [self.view addSubview:tip];
    
}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
#pragma mark ========== UICollectionViewDelegate ==========
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
