//
//  LibraryVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LibraryVC.h"
#import "LibraryModel.h"
#import "LibraryDraggableItem.h"
#import "PWFMDB.h"
#import "HandBookArticleVC.h"
#import "HandbookIndexVC.h"
#import "LibrarySearchVC.h"
#import "HandBookManager.h"
static NSUInteger kLineCount = 3;
static NSUInteger ItemHeight = 136;
static NSUInteger ItemWidth = 104;

@interface LibraryVC ()<PWDraggableItemDelegate>
@property (nonatomic, strong) NSMutableArray<LibraryModel *> *handbookArray;


@property (nonatomic, strong) UIView *searchView;
@end

@implementation LibraryVC
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = PWWhiteColor;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.frame= CGRectMake(0, Interval(28)+ZOOM_SCALE(36), kWidth, kHeight-kTopHeight-kTabBarHeight-Interval(74));
    self.mainScrollView.backgroundColor = PWWhiteColor;
    [self dealWithData];
    [self createUpUI];

}

- (void)createUpUI{
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    [self.searchView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchView);
        make.width.height.offset(ZOOM_SCALE(32));
        make.centerX.mas_equalTo(self.view).offset(-ZOOM_SCALE(21));
    }];
    UILabel *searchLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@"搜索"];
    [self.searchView addSubview:searchLab];
    [searchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(ZOOM_SCALE(6));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(22));
    }];
}
- (void)dealWithData{
    self.handbookArray = [[HandBookManager sharedInstance] getHandBooks];;
    [self createUI];
    [self loadDatas];
}
- (void)loadDatas{
    [PWNetworking requsetHasTokenWithUrl:PW_handbookList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[@"errorCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self compareWithData:content];
            }
        }else{
//            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)compareWithData:(NSArray *)array{
    NSMutableArray *handbook = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        LibraryModel *model = [[LibraryModel alloc]initWithDictionary:dict error:&error];
        [handbook addObject:model];
    }];


    NSArray *itemDatas = [[HandBookManager sharedInstance] getHandBooks];
    DLog(@"%@", itemDatas);
    if (itemDatas.count == 0) {
        [[HandBookManager sharedInstance] cacheHandBooks:handbook];
        self.handbookArray = [NSMutableArray arrayWithArray:handbook];
        [self createUI];
    } else {
        __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:5];
        //找到handbook中有,itemDatas中没有的数据
        [itemDatas enumerateObjectsUsingBlock:^(LibraryModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *modelStr = [model toJSONString];
            __block BOOL isHave = NO;
            [handbook enumerateObjectsUsingBlock:^(LibraryModel *newModel, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *newModelStr = [newModel toJSONString];
                if ([modelStr isEqualToString:newModelStr]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:model];
            }
        }];
        //找到arr1中有,arr2中没有的数据
        [itemDatas enumerateObjectsUsingBlock:^(LibraryModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *objStr = [obj toJSONString];
            __block BOOL isHave = NO;
            [handbook enumerateObjectsUsingBlock:^(LibraryModel *newobj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *newobjStr = [newobj toJSONString];
                if ([objStr isEqualToString:newobjStr]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        DLog(@"%@", difObject);
        if (difObject.count > 0) {
            [[HandBookManager sharedInstance] cacheHandBooks:difObject];
            NSArray *newitemDatas = [[HandBookManager sharedInstance] getHandBooks];
            [self.handbookArray removeAllObjects];
            self.handbookArray = [NSMutableArray arrayWithArray:newitemDatas];
            [self createUI];
        }
    }
//    }
//    else{
//        NSDictionary *dict = @{@"bucketPath":@"text",@"category":@"text",@"coverImageMobile":@"text",@"handbookId":@"text",@"name":@"text",@"orderNum":@"integer",@"coverImageMobile":@"text",@"PWId":@"text"};
//        if ([pwfmdb pw_createTable:tableName dicOrModel:dict primaryKey:@"PWId"]) {
//          BOOL  is= [pwfmdb pw_insertTable:tableName dicOrModelArray:handbook];
//        }
//        self.handbookArray = [NSMutableArray arrayWithArray:handbook];
//        [self createUI];
//    }
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    NSUInteger backImgCount = self.handbookArray.count%3 == 0? self.handbookArray.count/3:self.handbookArray.count/3+1;
    self.mainScrollView.contentSize = CGSizeMake(0, backImgCount*(ZOOM_SCALE(ItemHeight)+ZOOM_SCALE(18))+Interval(10));
    NSMutableArray *array = [NSMutableArray array];
    CGFloat width = ZOOM_SCALE(ItemWidth);
    CGFloat kMargin = (kWidth-kLineCount*width)/4.00;
    CGFloat height = ZOOM_SCALE(ItemHeight);

    for (NSInteger index = 0; index<self.handbookArray.count; index++) {
        LibraryModel *model = self.handbookArray[index];
        NSUInteger X = index % kLineCount;
        NSUInteger Y = index / kLineCount;
        LibraryDraggableItem *btn = [[LibraryDraggableItem alloc]init];
        btn.frame = CGRectMake(X * (width + kMargin) + kMargin, Y*(ZOOM_SCALE(ItemHeight)+ZOOM_SCALE(18))+Interval(10), width, height);
        btn.tag = index+10;
        btn.lineCount = kLineCount;
        btn.model = model;
        btn.delegate = self;
        if (model.coverImageMobile.length>0) {
            [btn.iconImgVie sd_setImageWithURL:[NSURL URLWithString:model.coverImageMobile] placeholderImage:[UIImage imageNamed:@"icon_book"] options:SDWebImageAllowInvalidSSLCertificates];
        }else{
            btn.iconImgVie.image = [UIImage imageNamed:@"icon_book"];
        }
        btn.clickBlock = ^(NSInteger index){
            NSLog(@"点击的是%ld",(long)index);
            [self loadHandBookDetail:index];
        };
        [[self.mainScrollView viewWithTag:10+index]removeFromSuperview];
        [self.mainScrollView addSubview:btn];
        [array addObject:btn];
        btn.btnArray = array;
    }
    
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), ZOOM_SCALE(36))];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        _searchView.layer.cornerRadius = 4.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
        [_searchView addGestureRecognizer:tap];
        [self.view addSubview:_searchView];
    }
    return _searchView;
}
- (void)searchClick{
    LibrarySearchVC *search = [[LibrarySearchVC alloc]init];
    search.isHidenNaviBar = YES;
    search.placeHolder = @"您好，请问有什么可以帮您？";
    [self.navigationController pushViewController:search animated:YES];
}
- (void)loadHandBookDetail:(NSInteger)index{
    
    LibraryModel *model = self.handbookArray[index];
    if ([model.category isEqualToString:@"column"]) {
        HandBookArticleVC *articale = [[HandBookArticleVC alloc]init];
        articale.model = model;
        [self.navigationController pushViewController:articale animated:YES];
    }else{
        HandbookIndexVC *indexVC = [[HandbookIndexVC alloc]init];
        indexVC.model = model;
        [self.navigationController pushViewController:indexVC animated:YES];
    }
   
    
}
#pragma mark ========== PWDraggableItemDelegate ==========
- (void)dragButton:(LibraryDraggableItem *)dragButton dragButtons:(NSArray *)dragButtons startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    if (endIndex<startIndex) {
        [self.handbookArray insertObject:self.handbookArray[startIndex] atIndex:endIndex];
        [self.handbookArray removeObjectAtIndex:startIndex + 1];
    }else{
        [self.handbookArray insertObject:self.handbookArray[startIndex] atIndex:endIndex + 1];
        [self.handbookArray removeObjectAtIndex:startIndex];
    }
    [[HandBookManager sharedInstance] cacheHandBooks:self.handbookArray];

}
- (void)dragCenter:(CGPoint)point{
    CGFloat frameHeight = self.mainScrollView.frame.size.height;
    CGFloat contentHeight = self.mainScrollView.contentSize.height;
    CGFloat offsetY = self.mainScrollView.contentOffset.y;
    if (contentHeight<=frameHeight) {
        return;
    }
    int y = offsetY;
    NSUInteger topY = y%ItemHeight==0?y/ItemHeight-1: offsetY/ItemHeight;
    NSUInteger bottomY = y%ItemHeight==0?y/ItemHeight+1: offsetY/ItemHeight;
    if (y>0) {
        if (point.y-offsetY<0) {
            [self.mainScrollView setContentOffset:CGPointMake(0, ItemHeight*topY) animated:YES];
        }
    }
    if (point.y-offsetY>frameHeight) {
        if(y<=0){
            bottomY = 0;
        }
        CGFloat moveY = ItemHeight*(bottomY+1);
        if (point.y-offsetY>0 && moveY<contentHeight-frameHeight+2*ItemHeight) {
            [self.mainScrollView setContentOffset:CGPointMake(0, moveY) animated:YES];
        }
    }
}
-(CATransition *)createTransitionAnimation
{
    //切换之前添加动画效果
    //后面知识: Core Animation 核心动画
    //不要写成: CATransaction
    //创建CATransition动画对象
    CATransition *animation = [CATransition animation];
    //设置动画的类型:
    animation.type = @"reveal";
    //设置动画的方向
    animation.subtype = kCATransitionFade;
    //设置动画的持续时间
    animation.duration = 0.5;
    //设置动画速率(可变的)
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画添加到切换的过程中
    return animation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
