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
@interface PWInfoBoard ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger cbID;
}
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *headRightBtn;
@property (nonatomic, assign) BOOL headerVisible;
@property (nonatomic, assign) BOOL isServiceConnect;
@property (nonatomic, assign) BOOL isInitial;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *rightBtnIcon;
@property (nonatomic, strong) UIButton *historyInfoBtn;
@property (nonatomic, strong) UICollectionView *itemCollectionView;
@property (nonatomic, copy) NSString *backgroungColorStr;
@property (nonatomic, copy) NSString *title;
@end

@implementation PWInfoBoard

#pragma mark - lifeCycle
-(instancetype)initWithFrame:(CGRect)frame paramsDic:(NSDictionary*)paramsDic {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
    }
    return self;
}
- (void)close:(NSDictionary *)paramsDict_ {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    self.historyInfoBtn = nil;
    self.itemCollectionView = nil;
    self.rightBtnIcon = nil;
    self.titleLable = nil;
    self.headRightBtn = nil;
    self.datas = nil;
}
#pragma mark - public method
- (void)openModel:(NSDictionary *)paramsDict_ cdid:(NSInteger)cdid{
    cbID = cdid;

        if (self.itemCollectionView) {
         
            NSMutableArray *data = [NSMutableArray arrayWithArray:paramsDict_[@"data"]];
            BOOL isReload = NO;
            for (int i=0; i<data.count; i++) {
                NSDictionary *dict= data[i];
                if ([dict[@"type"] isEqualToString:@"serviceConnect"]) {
                    isReload = YES;
                    [data removeObjectAtIndex:i];
                    break;
                }
            }
            if (isReload == self.isServiceConnect) {
                if (self.datas.count != data.count) {
                float top = isReload==NO?42*ZOOM_SCALE:323*ZOOM_SCALE;
                self.itemCollectionView.frame = CGRectMake(0, top, kWidth, 70*data.count*ZOOM_SCALE);
                }
                [self.datas removeAllObjects];
                [self.datas addObjectsFromArray:data];
                [self.itemCollectionView reloadData];
               

                return;
            }
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:data];
            self.isServiceConnect = isReload;
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.titleLable = nil;
            self.historyInfoBtn = nil;
            self.itemCollectionView = nil;
            self.rightBtnIcon = nil;
            [self createUIWithTypeisInitial:self.isServiceConnect];
            
        }else{
            [self config:paramsDict_];
        }
}
-(void )config:(NSDictionary *)paramsDict_{
    _datas = [NSMutableArray new];
    [self.datas addObjectsFromArray:paramsDict_[@"datas"]];
    self.isServiceConnect = NO;
    for (int i=0; i<self.datas.count; i++) {
        NSDictionary *dict= self.datas[i];
        if ([dict[@"type"] isEqualToString:@"serviceConnect"]) {
            self.isServiceConnect = YES;
            [self.datas removeObjectAtIndex:i];
            break;
        }
    }
    self.headerVisible =[paramsDict_ boolValueForKey:@"headerVisible" defaultValue:NO];
    self.headRightBtn = [paramsDict_ dictValueForKey:@"headRightBtn" defaultValue:@{}];
    self.backgroungColorStr = [paramsDict_ stringValueForKey:@"backgroundColor" defaultValue:@"#F8F8F8"];
    self.backgroundColor = [UZAppUtils colorFromNSString:self.backgroungColorStr];
    self.days = [paramsDict_ intValueForKey:@"days" defaultValue:0];
    self.title = [paramsDict_ stringValueForKey:@"title" defaultValue:@""];
    [self createUIWithTypeisInitial:self.isServiceConnect];
}
- (void)createUIWithTypeisInitial:(BOOL )isInitial {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(336*ZOOM_SCALE, 60*ZOOM_SCALE);
    layout.minimumLineSpacing = 10*ZOOM_SCALE;
    float top = isInitial==NO?42*ZOOM_SCALE:323*ZOOM_SCALE;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, top, kWidth, 70*self.datas.count*ZOOM_SCALE) collectionViewLayout:layout];
    [collectionView registerClass:[PWInfoBoardCell class] forCellWithReuseIdentifier:@"cellId"];
    self.itemCollectionView = collectionView;
    self.itemCollectionView.backgroundColor = [UZAppUtils colorFromNSString:self.backgroungColorStr];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [self addSubview:self.itemCollectionView];
    [self.itemCollectionView reloadData];
    if (isInitial == YES) {
        PWInfoInitialView *headerView = [[PWInfoInitialView alloc]initWithFrame:CGRectMake(12*ZOOM_SCALE, 43*ZOOM_SCALE, 336*ZOOM_SCALE, 271*ZOOM_SCALE)];
        headerView.tag = 555;
        headerView.serverConnectClick = ^(void){
            NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [sendDict setObject:@"serverConnectClick"  forKey:@"eventType"];
            [sendDict setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
            [_module sendResultEventWithCallbackId:cbID dataDict:sendDict errDict:nil doDelete:NO];
        };
        [[self viewWithTag:555] removeFromSuperview];
        [self addSubview:headerView];
        
    }
        if (!_titleLable) {
            _titleLable = [[UILabel alloc] init];
            _titleLable.frame = CGRectMake(13*ZOOM_SCALE, 12*ZOOM_SCALE, 200*ZOOM_SCALE, 17*ZOOM_SCALE);
            _titleLable.font = [UIFont systemFontOfSize:12];
            _titleLable.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
            [self addSubview:_titleLable];
        }
        _titleLable.text = self.title;
        NSString *btnTitle;
        NSString *btnIcon;
        if(self.headRightBtn.allKeys.count == 0){
            btnTitle = @"历史情报";
            btnIcon = @"res_PWInfoBoard/icon_history@2x";
        }else{
            btnTitle = [self.headRightBtn stringValueForKey:@"title" defaultValue:@""];
            btnIcon = [self.headRightBtn stringValueForKey:@"icon" defaultValue:@""];
        }
         CGSize btnSize = [self sizeWithStr:btnTitle Width:kWidth withFont:[UIFont systemFontOfSize:14]];
        if (!_rightBtnIcon) {
            _rightBtnIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:_rightBtnIcon];
        }
        if(!_historyInfoBtn){
            _historyInfoBtn = [[UIButton alloc] init];
             _historyInfoBtn.frame = CGRectMake((348*ZOOM_SCALE-btnSize.width), 12*ZOOM_SCALE, btnSize.width, 20*ZOOM_SCALE);
            [_historyInfoBtn setTitle:btnTitle forState:UIControlStateNormal];
            _historyInfoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_historyInfoBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            [_historyInfoBtn addTarget:self action:@selector(historyInfoClick) forControlEvents:UIControlEventTouchUpInside];
            _historyInfoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_historyInfoBtn sizeToFit];
            [self addSubview:_historyInfoBtn];
        }
        if([btnIcon isEqualToString:@""]){
            self.rightBtnIcon.hidden = YES;
        }else{
            self.rightBtnIcon.hidden = NO;
            self.rightBtnIcon.frame = CGRectMake(CGRectGetMinX(self.historyInfoBtn.frame)-23*ZOOM_SCALE, 12*ZOOM_SCALE, 20*ZOOM_SCALE, 20*ZOOM_SCALE);
            if([btnIcon hasPrefix:@"widget:"]){
                self.rightBtnIcon.image = [UIImage imageWithContentsOfFile:[self.module getPathWithUZSchemeURL:btnIcon]];
            }else{
                self.rightBtnIcon.image = [UIImage imageWithContentsOfFile:LOADIMAGE(btnIcon, @"png")];
            }
        }
        CGPoint center = self.historyInfoBtn.center;
        center.x = self.rightBtnIcon.center.x;
        self.rightBtnIcon.center = center;
        if([btnTitle isEqualToString:@""]){
           self.historyInfoBtn.hidden = YES;
        }else{
            self.historyInfoBtn.hidden = NO;
        }
    if (_titleLable) {
        _titleLable.frame = CGRectMake(12*ZOOM_SCALE, 12*ZOOM_SCALE,CGRectGetMidX(self.rightBtnIcon.frame)-15*ZOOM_SCALE, 17*ZOOM_SCALE);
        CGPoint center = _titleLable.center;
        center.x = self.rightBtnIcon.center.x;
        self.rightBtnIcon.center = center;
        center.x = self.historyInfoBtn.center.x;
        self.historyInfoBtn.center = center;
    }
    
}
- (void)updateItem:(NSDictionary *)paramsDict_{
    BOOL is = NO;
    NSInteger cbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSInteger index = [paramsDict_ integerValueForKey:@"index" defaultValue:0];
    NSDictionary *data = [paramsDict_ dictValueForKey:@"data" defaultValue:@{}];
    if (index>=0 && index<self.datas.count && data.allKeys.count>0) {
        NSString *count =[NSString stringWithFormat:@"%@",self.datas[index][@"messageCount"]];
        if(![[self.datas[index] allKeys] containsObject:@"messageCount"]){
            count = @"";
        }
        NSIndexPath *index2 = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *keys = [data allKeys];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.datas[index]];
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
        if (![newCount isEqualToString:count] && [data intValueForKey:@"state" defaultValue:1] != 1 && newCount.length>0) {
           PWInfoBoardCell *cell = (PWInfoBoardCell *)[self.itemCollectionView cellForItemAtIndexPath:index2];
                [cell bump];
        }
        });
        is = YES;
    }
   
}
- (void)updateTitle:(NSDictionary *)paramsDict_{
    //如果 是否显示顶部文字描述与历史操作为否 直接返回
    NSInteger cbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    
    BOOL is = NO;
    if(self.headerVisible == YES){
        if (self.titleLable) {
            self.title = [paramsDict_ stringValueForKey:@"title" defaultValue:@""];
            self.titleLable.text = self.title;
            is = YES;
        }
    }
}

#pragma mark - private methods
- (void)historyInfoClick{
    
}
-(CGSize)sizeWithStr:(NSString *)str Width:(CGFloat)width withFont:(UIFont*)font{
    if (@available(iOS 7.0, *)) {
        return [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    } else {
        return CGSizeZero;
        
    }
}
#pragma mark - collection data
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PWInfoBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.datas = self.datas[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 8*ZOOM_SCALE;
    return cell;
}
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

