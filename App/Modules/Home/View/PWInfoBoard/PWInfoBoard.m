//
//  PWInfoBoardView.m
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/29.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWInfoBoard.h"
#import "PWInfoBoardCell.h"
#import "PWInfoInitialView.h"
@interface PWInfoBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,PWInfoInitialViewDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *headRightBtn;
@property (nonatomic, assign) PWInfoBoardStyle style;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *rightBtnIcon;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UICollectionView *itemCollectionView;
@property (nonatomic, strong) PWInfoInitialView *initializeView;
@end

@implementation PWInfoBoard

#pragma mark ========== 初始化 ==========
-(instancetype)initWithFrame:(CGRect)frame style:(PWInfoBoardStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.style = style;
    }
    return self;
}

#pragma mark ========== UI布局 ==========
- (void)createUIWithParamsDict:(NSDictionary *)paramsDict{
     _datas = [NSMutableArray new];
    [_datas addObjectsFromArray:paramsDict[@"datas"]];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ZOOM_SCALE(12));
        make.top.mas_equalTo(ZOOM_SCALE(12));
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self.rightBtnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn).offset(ZOOM_SCALE(3));
        make.width.offset(ZOOM_SCALE(20));
        make.height.offset(ZOOM_SCALE(20));
        make.center.centerY.equalTo(self.rightBtn);
    }];
    self.rightBtnIcon.image = [UIImage imageNamed:@""];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ZOOM_SCALE(12));
        make.right.equalTo(self.rightBtnIcon).offset(10);
        make.height.offset(ZOOM_SCALE(20));
        make.center.centerY.equalTo(self.rightBtnIcon);
    }];
    self.titleLable.text = @"";
    if (self.style == PWInfoBoardStyleNotConnected) {
        self.titleLable.hidden = YES;
        self.initializeView.hidden = NO;
    }else{
        self.titleLable.hidden = NO;
        _initializeView.hidden = YES;
        [_initializeView removeFromSuperview];
    }
    float top = self.style==PWInfoBoardStyleConnected?ZOOM_SCALE(42):ZOOM_SCALE(323);
    self.itemCollectionView.frame = CGRectMake(0, top, kWidth, ZOOM_SCALE(70*self.datas.count));
    
}

- (UICollectionView *)itemCollectionView{
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(ZOOM_SCALE(336), ZOOM_SCALE(60));
        layout.minimumLineSpacing = ZOOM_SCALE(10);
       _itemCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        _itemCollectionView.scrollEnabled = NO;
        [_itemCollectionView registerClass:[PWInfoBoardCell class] forCellWithReuseIdentifier:@"cellId"];
        [self addSubview:_itemCollectionView];

    }
    return _itemCollectionView;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:12];
        _titleLable.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:_titleLable];
    }
    return _titleLable;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(historyInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}
-(UIImageView *)rightBtnIcon{
    if (!_rightBtnIcon) {
        _rightBtnIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_rightBtnIcon];
    }
    return _rightBtnIcon;
}
-(PWInfoInitialView *)initializeView{
    if(!_initializeView){
        _initializeView = [[PWInfoInitialView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(12), ZOOM_SCALE(43), ZOOM_SCALE(336), ZOOM_SCALE(271))];
        _initializeView.delegate = self;
        [self addSubview:_initializeView];
    }
    return _initializeView;
}
#pragma mark ========== 实例方法 ==========
- (void)updataInfoBoardStyle:(PWInfoBoardStyle)style itemData:(NSDictionary *)paramsDict{
    NSArray *data = paramsDict[@"data"];
    if(data.count>0){
        if(self.style != style){
                  self.style = style;
            float top = self.style==PWInfoBoardStyleConnected?ZOOM_SCALE(42):ZOOM_SCALE(323);
            self.itemCollectionView.frame = CGRectMake(0, top, kWidth, ZOOM_SCALE(70*self.datas.count));
            if (self.style == PWInfoBoardStyleNotConnected) {
                self.titleLable.hidden = YES;
                self.initializeView.hidden = NO;
            }else{
                self.initializeView.hidden = YES;
                [self.initializeView removeFromSuperview];
                self.titleLable.hidden = NO;
            }
        }
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:data];
        [self.itemCollectionView reloadData];
    }
    
}
- (void)updataDatas:(NSDictionary *)paramsDict{
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:paramsDict[@"datas"]];
    [self.itemCollectionView reloadData];
}
- (void)updateItem:(NSDictionary *)paramsDict{
    NSInteger index = [paramsDict integerValueForKey:@"index" default:0];
    NSDictionary *data = paramsDict[@"data"];
    if (index>=0 && index<self.datas.count && data.allKeys.count>0) {

        NSIndexPath *index2 = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *keys = [data allKeys];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.datas[index]];
        NSString *count = [NSString stringWithFormat:@"%@",dict[@"messageCount"]];
        for (NSString *key in keys) {
            [dict removeObjectForKey:key];
            [dict setValue:data[key] forKey:key];
        }
        NSString *newCount = [NSString stringWithFormat:@"%@",data[@"messageCount"]];
        if(![[data allKeys] containsObject:@"messageCount"]){
            newCount = @"";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datas replaceObjectAtIndex:index withObject:dict];
            [self.itemCollectionView reloadItemsAtIndexPaths:@[index2]];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
        if (![newCount isEqualToString:count] && [data intValueForKey:@"state" default:1] != 1 && newCount.length>0) {
           PWInfoBoardCell *cell = (PWInfoBoardCell *)[self.itemCollectionView cellForItemAtIndexPath:index2];
                [cell bump];
        }
        });
    }
}
- (void)updateTitle:(NSString *)title{
        if (self.titleLable) {
            self.titleLable.text = title;
        }
}
#pragma mark ========== private methods ==========
- (void)historyInfoBtnClick{
    if (self.historyInfoClick) {
        self.historyInfoClick();
    }
}
- (void)serverConnectClick{
    if (self.connectClick) {
        self.connectClick();
    }
}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.datas = self.datas[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = ZOOM_SCALE(8);
    return cell;
}
#pragma mark ========== UICollectionViewDelegate ==========
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = (PWInfoBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowRadius = 5;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = (PWInfoBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0,1);
    cell.layer.shadowRadius = 1;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = (PWInfoBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowRadius = 5;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */




@end

