//
//  ExpertsSuggestVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ExpertsSuggestVC.h"
#import "ExpertCell.h"
#import "TeamInfoModel.h"
#import "ExpertsDetailVC.h"
#import "ExpertsMoreVC.h"

@interface ExpertsSuggestVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *expertCollection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ExpertsSuggestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家建议";
    [self createUI];
}
- (void)createUI{
    DLog(@"teamModel == %@",userManager.teamModel);
    self.dataSource = [NSMutableArray new];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(14), kWidth-Interval(32), ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTitleColor text:@"邀请专家加入到您的讨论中"];
    [self.view addSubview:tipLab];
    NSMutableArray *array = userManager.expertGroups;
    if (userManager.teamModel !=nil) {
        NSDictionary *tags =userManager.teamModel.tags;
        NSDictionary *product = tags[@"product"];
        NSString *managed = [product stringValueForKey:@"managed" default:@""];
        NSString *support = [product stringValueForKey:@"support" default:@""];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
          __block  BOOL isHave = NO;
            NSArray *managedAry =obj[@"managed"];
            NSArray *supportAry = obj[@"support"];
            [managedAry enumerateObjectsUsingBlock:^(NSString *manaobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([manaobj isEqualToString:managed]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (isHave == NO) {
                [supportAry enumerateObjectsUsingBlock:^(NSString *suppobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([suppobj isEqualToString:support]){
                        isHave = YES;
                        *stop = YES;
                    }
                }];
            }
            isHave == YES? [self.dataSource addObject:obj]:nil;
        }];
    }
    

     NSArray *more = @[@"more"];
    [self.dataSource addObject:more];
    [self.expertCollection reloadData];
    self.expertCollection.delegate = self;
}
- (UICollectionView *)expertCollection{
    if (!_expertCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(ZOOM_SCALE(166), ZOOM_SCALE(130));
        layout.sectionInset =UIEdgeInsetsMake(Interval(5),ZOOM_SCALE(16), 5, ZOOM_SCALE(16));

        layout.minimumLineSpacing = ZOOM_SCALE(11);
        _expertCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Interval(46), kWidth, kHeight-kTopHeight-Interval(51)) collectionViewLayout:layout];
        _expertCollection.delegate = self;
        _expertCollection.dataSource = self;
        _expertCollection.showsVerticalScrollIndicator = NO;
        _expertCollection.backgroundColor = PWBackgroundColor;
        [_expertCollection registerClass:[ExpertCell class] forCellWithReuseIdentifier:@"ExpertCell"];
        [self.view addSubview:_expertCollection];
        
    }
    return _expertCollection;
}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExpertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpertCell" forIndexPath:indexPath];
    if (indexPath.row != self.dataSource.count-1) {
  
    NSDictionary *data = self.dataSource[indexPath.row];
    __block BOOL isInvite = NO;
    if(_expertGroups && _expertGroups.count>0){
        [self.expertGroups enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isEqualToString:[data stringValueForKey:@"expertGroup" default:@""]]){
                isInvite = YES;
                *stop = YES;
            }
        }];
    }
    cell.isMore = NO;
    cell.isInvite = isInvite;
    cell.data = data;
    }else{
    cell.isMore = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.dataSource.count-1) {
        ExpertsDetailVC *detailVC = [[ExpertsDetailVC alloc]init];
        detailVC.data = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ExpertsMoreVC *moreVC = [[ExpertsMoreVC alloc]init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    ExpertCell *cell = (ExpertCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0,1);
    cell.layer.shadowRadius = 1;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    ExpertCell *cell = (ExpertCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell.isInvite){
        cell.layer.shadowOffset = CGSizeMake(0,10);
        cell.layer.shadowRadius = 10;
    }else{
    cell.layer.shadowOffset = CGSizeMake(0,4);
    cell.layer.shadowRadius = 4;
    }
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
