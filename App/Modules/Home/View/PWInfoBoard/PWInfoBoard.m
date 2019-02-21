//
//  PWInfoBoardView.m
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/29.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWInfoBoard.h"
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
    
    if (self.style == PWInfoBoardStyleNotConnected) {
        self.titleLable.hidden = NO;
        self.initializeView.hidden = NO;
        [self.initializeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self).offset(Interval(16));
            make.right.mas_equalTo(self).offset(Interval(-16));
            make.height.offset(ZOOM_SCALE(586));
        }];
    }else{
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(ZOOM_SCALE(12));
            make.right.mas_equalTo(self).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(30));
            make.width.offset(ZOOM_SCALE(100));
        }];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Interval(16));
            make.right.mas_equalTo(self.rightBtn.mas_left).offset(10);
            make.height.offset(ZOOM_SCALE(20));
            make.centerY.equalTo(self.rightBtn.mas_centerY);
        }];
        self.titleLable.text = @"检测时间";
        self.titleLable.hidden = NO;
        _initializeView.hidden = YES;
        [_initializeView removeFromSuperview];
        self.itemCollectionView.frame = CGRectMake(0, ZOOM_SCALE(42), kWidth, ZOOM_SCALE(82*self.datas.count));
    }
    
}

- (UICollectionView *)itemCollectionView{
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(kWidth-2*Interval(16), ZOOM_SCALE(64));
        layout.minimumLineSpacing = ZOOM_SCALE(18);
        _itemCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        _itemCollectionView.scrollEnabled = NO;
        _itemCollectionView.backgroundColor = PWBackgroundColor;
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
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn setTitle:@"配置情报源" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn sizeToFit];
        // 重点位置开始
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_rightBtn.imageView.frame.size.width - _rightBtn.frame.size.width + _rightBtn.titleLabel.frame.size.width, 0, 0);
        
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_rightBtn.titleLabel.frame.size.width - _rightBtn.frame.size.width + _rightBtn.imageView.frame.size.width);
        
        // 重点位置结束
//        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBtn addTarget:self action:@selector(historyInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
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
        _initializeView = [[PWInfoInitialView alloc]initWithFrame:CGRectZero];
        _initializeView.delegate = self;
        [self addSubview:_initializeView];
    }
    return _initializeView;
}
#pragma mark ========== 实例方法 ==========
- (void)updataInfoBoardStyle:(PWInfoBoardStyle)style itemData:(NSDictionary *)paramsDict{
    NSArray *data = paramsDict[@"datas"];
        if(data.count>0){
        if(self.style != style){
            self.style = style;
            [self.initializeView removeFromSuperview];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(ZOOM_SCALE(12));
                make.right.mas_equalTo(self).offset(-Interval(16));
                make.height.offset(ZOOM_SCALE(30));
                make.width.offset(ZOOM_SCALE(100));
            }];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Interval(16));
                make.right.mas_equalTo(self.rightBtn.mas_left).offset(10);
                make.height.offset(ZOOM_SCALE(20));
                make.centerY.equalTo(self.rightBtn.mas_centerY);
            }];
            self.titleLable.text = @"检测时间";
            self.titleLable.hidden = NO;
            _initializeView.hidden = YES;
            [_initializeView removeFromSuperview];
            self.itemCollectionView.frame = CGRectMake(0, ZOOM_SCALE(42), kWidth, ZOOM_SCALE(82*self.datas.count));
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
    DLog(@"click");
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
    cell.model = self.datas[indexPath.row];
    return cell;
}
#pragma mark ========== UICollectionViewDelegate ==========
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = (PWInfoBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.itemClick) {
        self.itemClick(indexPath.row);
    }
    
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

