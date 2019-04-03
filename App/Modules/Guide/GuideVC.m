//
//  GuideVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "GuideVC.h"
#import "GuideCell.h"

@interface GuideVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *guideCollection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *page1btn;
@property (nonatomic, strong) UIButton *page2btn;
@property (nonatomic, strong) UIButton *page3btn;

@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    self.dataSource = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
    self.guideCollection.frame = CGRectMake(0, 0, kWidth, kHeight);
    [self createUI];

}
- (void)createUI{

    [self.page2btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.offset(ZOOM_SCALE(30));
        make.height.offset(ZOOM_SCALE(8));
        make.bottom.offset(-ZOOM_SCALE(95)-SafeAreaBottom_Height);
    }];
    [self.page1btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ZOOM_SCALE(30));
        make.height.offset(ZOOM_SCALE(8));
        make.bottom.offset(-ZOOM_SCALE(95)-SafeAreaBottom_Height);
        make.right.mas_equalTo(self.page2btn.mas_left).offset(-ZOOM_SCALE(15));
    }];
    [self.page3btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ZOOM_SCALE(30));
        make.height.offset(ZOOM_SCALE(8));
        make.bottom.offset(-ZOOM_SCALE(95)-SafeAreaBottom_Height);
        make.left.mas_equalTo(self.page2btn.mas_right).offset(ZOOM_SCALE(15));
    }];


}

- (UICollectionView *)guideCollection{
    if (!_guideCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(kWidth, kHeight);
        layout.minimumLineSpacing = 0;
        _guideCollection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _guideCollection.delegate = self;
        _guideCollection.dataSource = self;
        _guideCollection.pagingEnabled = YES;
        _guideCollection.showsHorizontalScrollIndicator = NO;
        [_guideCollection registerClass:GuideCell.class forCellWithReuseIdentifier:@"GuideCell"];
        [self.view addSubview:_guideCollection];

    }
    return _guideCollection;
}
-(UIButton *)page1btn{
    if (!_page1btn) {
        _page1btn = [[UIButton alloc]init];
        [_page1btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#7EA7FF"]] forState:UIControlStateNormal];
        [_page1btn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateSelected];
        [_page1btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _page1btn.tag = 1;
        _page1btn.selected = YES;
        [self.view addSubview:_page1btn];
    }
    return _page1btn;
}
-(UIButton *)page2btn{
    if (!_page2btn) {
        _page2btn = [[UIButton alloc]init];
        [_page2btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#7EA7FF"]] forState:UIControlStateNormal];
        [_page2btn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateSelected];
         [_page2btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _page2btn.tag = 2;
        [self.view addSubview:_page2btn];
    }
    return _page2btn;
}
-(UIButton *)page3btn{
    if (!_page3btn) {
        _page3btn = [[UIButton alloc]init];
        [_page3btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#7EA7FF"]] forState:UIControlStateNormal];
        [_page3btn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateSelected];
        _page3btn.tag = 3;
         [_page3btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_page3btn];
    }
    return _page3btn;
}
- (void)btnClick:(UIButton *)button{

    [self dealWithSelected:button.tag];
    [self.guideCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
- (void)dealWithSelected:(NSInteger)index{

    if (index == 1) {
        self.page1btn.selected = YES;
        self.page2btn.selected = NO;
        self.page3btn.selected = NO;
    }else if (index == 2){
        self.page1btn.selected = NO;
        self.page2btn.selected = YES;
        self.page3btn.selected = NO;
    }else if(index == 3){
        self.page1btn.selected = NO;
        self.page2btn.selected = NO;
        self.page3btn.selected = YES;
    }

}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return  self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuideCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.itemClick = ^(NSInteger index){
        if (index == 4) {
            KPostNotification(KNotificationLoginStateChange, @NO);
        }
    };
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGRect visibleRect = (CGRect) {.origin = self.guideCollection.contentOffset, .size = self.guideCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.guideCollection indexPathForItemAtPoint:visiblePoint];
    [self dealWithSelected:visibleIndexPath.row + 1];
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
