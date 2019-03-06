//
//  ThinkTankVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "ThinkTankVC.h"
#import "PWDraggableModel.h"
#import "PWDraggableItem.h"
#import "PWFMDB.h"

static NSUInteger kLineCount = 3;
static NSUInteger ItemHeight = 136;
static NSUInteger ItemWidth = 104;

@interface ThinkTankVC ()<PWDraggableItemDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray<PWDraggableModel *> *handbookArray;


@property (nonatomic, strong) UISearchBar *searchTf;
@end

@implementation ThinkTankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.backgroundColor = PWWhiteColor;
    self.mainScrollView.frame= CGRectMake(0, Interval(64), kWidth, kHeight-kTopHeight-kTabBarHeight-Interval(74));
    [self createUpUI];
    [self dealWithData];
   
    
}

- (void)createUpUI{
    self.searchTf.backgroundColor = PWBackgroundColor;
    self.searchTf.userInteractionEnabled = NO;
    self.searchTf.placeholder = @"搜索";
}
- (void)dealWithData{
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = [NSString stringWithFormat:@"%@handbook",getPWUserID];
    if([pwfmdb  pw_isExistTable:tableName]){
       NSArray *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[PWDraggableModel class] whereFormat:nil];
        if (itemDatas.count>0) {
            self.handbookArray = [NSMutableArray arrayWithArray:itemDatas];
            [self createUI];
        }
    }
    [self loadDatas];
}
- (void)loadDatas{
    [PWNetworking requsetHasTokenWithUrl:PW_handbookList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self compareWithData:content];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)compareWithData:(NSArray *)array{
    NSMutableArray *handbook = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        PWDraggableModel *model = [[PWDraggableModel alloc]initWithDictionary:dict error:&error];
        model.PWId = nil;
        [handbook addObject:model];
    }];
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = [NSString stringWithFormat:@"%@handbook",getPWUserID];
    if([pwfmdb  pw_isExistTable:tableName]){
        NSArray *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[PWDraggableModel class] whereFormat:nil];
        DLog(@"%@",itemDatas);
        if (itemDatas.count==0) {
            BOOL  is= [pwfmdb pw_insertTable:tableName dicOrModelArray:array];
            self.handbookArray = [NSMutableArray arrayWithArray:handbook];
            [self createUI];
        }else{
            __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:5];
            //找到handbook中有,itemDatas中没有的数据
            [itemDatas enumerateObjectsUsingBlock:^(PWDraggableModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *modelStr = [model toJSONString];
                __block BOOL isHave = NO;
                [handbook enumerateObjectsUsingBlock:^(PWDraggableModel *newModel, NSUInteger idx, BOOL * _Nonnull stop) {
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
            [itemDatas enumerateObjectsUsingBlock:^(PWDraggableModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *objStr = [obj toJSONString];
                __block BOOL isHave = NO;
                [handbook enumerateObjectsUsingBlock:^(PWDraggableModel *newobj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            DLog(@"%@",difObject);
            if (difObject.count>0) {
                [difObject enumerateObjectsUsingBlock:^(PWDraggableModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *format =[NSString stringWithFormat:@"where handbookId = '%@'",obj.handbookId];
                   NSArray *array = [pwfmdb pw_lookupTable:tableName dicOrModel:[PWDraggableModel class] whereFormat:format];
                    if (array.count==1) {
                        [pwfmdb pw_updateTable:tableName dicOrModel:[PWDraggableModel class] whereFormat:format];
                    }else{
                        [pwfmdb pw_insertTable:tableName dicOrModel:obj];
                    }
                }];
              NSArray *newitemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[PWDraggableModel class] whereFormat:nil];
                [self.handbookArray removeAllObjects];
                self.handbookArray = [NSMutableArray arrayWithArray:newitemDatas];
                [self createUI];
            }
       }
    }else{
        NSDictionary *dict = @{@"bucketPath":@"text",@"category":@"text",@"coverImageMobile":@"text",@"handbookId":@"text",@"name":@"text",@"orderNum":@"integer",@"coverImageMobile":@"text",@"PWId":@"text"};
        if ([pwfmdb pw_createTable:tableName dicOrModel:dict primaryKey:@"PWId"]) {
          BOOL  is= [pwfmdb pw_insertTable:tableName dicOrModelArray:handbook];
        }
        self.handbookArray = [NSMutableArray arrayWithArray:handbook];
        [self createUI];
    }
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
        PWDraggableModel *model = self.handbookArray[index];
        model.orderNum = index;
        NSUInteger X = index % kLineCount;
        NSUInteger Y = index / kLineCount;
        PWDraggableItem *btn = [[PWDraggableItem alloc]init];
        btn.frame = CGRectMake(X * (width + kMargin) + kMargin, Y*(ZOOM_SCALE(ItemHeight)+ZOOM_SCALE(18))+Interval(10), width, height);
        btn.tag = index+10;
        btn.lineCount = kLineCount;
        btn.model = model;
        btn.delegate = self;
        [btn.iconImgVie sd_setImageWithURL:[NSURL URLWithString:model.coverImageMobile] placeholderImage:[UIImage imageNamed:@"icon_book"]];
        btn.iconImgVie.image = [UIImage imageNamed:@"icon_book"];
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
-(UISearchBar *)searchTf{
    if (!_searchTf) {
        _searchTf = [[UISearchBar alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), Interval(36))];
        [_searchTf setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F1F2F5"]]];
        //设置背景色
        [_searchTf setBackgroundColor:[UIColor clearColor]];
        _searchTf.delegate =self;
        //设置文本框背景
        [_searchTf setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F1F2F5"]] forState:UIControlStateNormal];
        _searchTf.layer.cornerRadius = 4.0f;
        _searchTf.layer.masksToBounds = YES;
        [self.view addSubview:_searchTf];
    }
    return _searchTf;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
- (void)loadHandBookDetail:(NSInteger)index{
    PWDraggableModel *model = self.handbookArray[index];
    [PWNetworking requsetWithUrl:PW_handbook(model.handbookId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        
    } failBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark ========== PWDraggableItemDelegate ==========
- (void)dragButton:(PWDraggableItem *)dragButton dragButtons:(NSArray *)dragButtons startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    if (endIndex<startIndex) {
        [self.handbookArray insertObject:self.handbookArray[startIndex] atIndex:endIndex];
        [self.handbookArray removeObjectAtIndex:startIndex + 1];
    }else{
        [self.handbookArray insertObject:self.handbookArray[startIndex] atIndex:endIndex + 1];
        [self.handbookArray removeObjectAtIndex:startIndex];
    }
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = [NSString stringWithFormat:@"%@handbook",getPWUserID];
    [pwfmdb pw_deleteAllDataFromTable:tableName];
    [pwfmdb pw_insertTable:tableName dicOrModelArray:self.handbookArray];
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
