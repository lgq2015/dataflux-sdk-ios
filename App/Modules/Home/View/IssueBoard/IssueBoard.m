//
//  PWInfoBoardView.m
//  IssueBoard
//
//  Created by 胡蕾蕾 on 2018/8/29.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "IssueBoard.h"
#import "IssueBoardInitialView.h"
#import "IssueListManger.h"
#define itemHeight ZOOM_SCALE(64)
#define LineSpacing ZOOM_SCALE(12)
@interface IssueBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,PWInfoInitialViewDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *headRightBtn;
@property (nonatomic, assign) PWIssueBoardStyle style;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *rightBtnIcon;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UICollectionView *itemCollectionView;
@property (nonatomic, strong) IssueBoardInitialView *initializeView;
@end

@implementation IssueBoard

#pragma mark ========== 初始化 ==========
-(instancetype)initWithStyle:(PWIssueBoardStyle)style{
    if (self = [super init]) {
        self.style = style;
    }
    return self;
}

#pragma mark ========== UI布局 ==========
- (void)createUIWithParamsDict:(NSDictionary *)paramsDict{
     _datas = [NSMutableArray new];
    [_datas addObjectsFromArray:paramsDict[@"datas"]];
 
    if (self.style == PWIssueBoardStyleNotConnected) {
        self.titleLable.hidden = NO;
        self.initializeView.hidden = NO;
        [self.initializeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(ZOOM_SCALE(12));
            make.left.mas_equalTo(self).offset(Interval(16));
            make.right.mas_equalTo(self).offset(Interval(-16));
            make.height.offset(ZOOM_SCALE(586));
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.initializeView);
        }];
    }else{
        CGFloat width = self.rightBtn.frame.size.width;
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(ZOOM_SCALE(6));
            make.right.mas_equalTo(self).offset(-Interval(12));
            make.height.offset(ZOOM_SCALE(30));
            make.width.offset(width);
        }];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Interval(16));
            make.right.mas_equalTo(self.rightBtn.mas_left).offset(10);
            make.top.mas_equalTo(self).offset(Interval(12));
        }];
        self.titleLable.text = @"检测时间";
        self.titleLable.hidden = NO;
        _initializeView.hidden = YES;
        [_initializeView removeFromSuperview];
        self.itemCollectionView.frame = CGRectMake(0, ZOOM_SCALE(42), kWidth, ZOOM_SCALE(76 * 5));
        [self.itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLable.mas_bottom).offset(Interval(12));
            make.left.right.mas_equalTo(self);
            make.height.offset((itemHeight+LineSpacing)*5);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.itemCollectionView);
        }];
    }
    
}

- (UICollectionView *)itemCollectionView{
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //该方法也可以设置itemSize
        layout.itemSize =CGSizeMake(kWidth-2*Interval(16), itemHeight);
        layout.minimumLineSpacing = LineSpacing;
        _itemCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        _itemCollectionView.scrollEnabled = NO;
        _itemCollectionView.backgroundColor = PWBackgroundColor;
        [_itemCollectionView registerClass:[IssueBoardCell class] forCellWithReuseIdentifier:@"cellId"];
        [self addSubview:_itemCollectionView];
    }
    return _itemCollectionView;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:@""];
        _titleLable.numberOfLines = 0;
        
        [self addSubview:_titleLable];
    }
    return _titleLable;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn setTitle:@"连接云服务" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"home_infoBoard_connect"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = RegularFONT(13);
        [_rightBtn sizeToFit];
        [_rightBtn addTarget:self action:@selector(historyInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

-(IssueBoardInitialView *)initializeView{
    if(!_initializeView){
        _initializeView = [[IssueBoardInitialView alloc]initWithFrame:CGRectZero];
        _initializeView.delegate = self;
        [self addSubview:_initializeView];
    }
    return _initializeView;
}
#pragma mark ========== 实例方法 ==========
- (void)updataInfoBoardStyle:(PWIssueBoardStyle)style itemData:(NSDictionary *)paramsDict{
    NSArray *data = paramsDict[@"datas"];
        if(data.count>0){
        if(self.style != style && style == PWIssueBoardStyleConnected){
            self.style = style;
            [self.initializeView removeFromSuperview];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(ZOOM_SCALE(6));
                make.right.mas_equalTo(self).offset(-Interval(16));
                make.height.offset(ZOOM_SCALE(30));
                make.width.offset(ZOOM_SCALE(70));
            }];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Interval(16));
                make.right.mas_equalTo(self.rightBtn.mas_left).offset(10);
                make.height.offset(ZOOM_SCALE(20));
                make.centerY.equalTo(self.rightBtn.mas_centerY);
            }];
            self.titleLable.text = @"检测时间";
            self.titleLable.hidden = NO;
           
            self.itemCollectionView.frame = CGRectMake(0, ZOOM_SCALE(42), kWidth, (itemHeight+LineSpacing)*5);
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.itemCollectionView);
            }];
        }
            [self updataDatas:paramsDict];
        }else{
            // 由已连接变为未连接 但是目前业务没有此需求
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
           IssueBoardCell *cell = (IssueBoardCell *)[self.itemCollectionView cellForItemAtIndexPath:index2];
                [cell bump];
        }
        });
    }
}
- (void)updateTitle:(NSString *)title{
    if (self.titleLable) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8; // 调整行间距
        NSRange range = NSMakeRange(0, [title length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        self.titleLable.attributedText = attributedString;
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
    IssueBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    cell.isShow = !cell.model.read;
    return cell;
}
#pragma mark ========== UICollectionViewDelegate ==========
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IssueBoardCell *cell = (IssueBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.itemClick) {
        self.itemClick(indexPath.row);
    }

    cell.model.read=YES;
    cell.isShow = NO;
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowRadius = 5;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    IssueBoardCell *cell = (IssueBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0,1);
    cell.layer.shadowRadius = 1;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    IssueBoardCell *cell = (IssueBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
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

