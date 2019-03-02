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
@property (nonatomic, strong) NSMutableArray *handbookArray;


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
       NSArray *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[NSDictionary class] whereFormat:nil];
        if (itemDatas.count>0) {
            self.handbookArray = [NSMutableArray arrayWithArray:itemDatas];
            [self createUI];
        }
    }
    [self loadDatas];
}
- (void)loadDatas{
    self.handbookArray = [NSMutableArray new];
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
 
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *tableName = [NSString stringWithFormat:@"%@handbook",getPWUserID];
    if([pwfmdb  pw_isExistTable:tableName]){
        NSArray *itemDatas = [pwfmdb pw_lookupTable:tableName dicOrModel:[NSDictionary class] whereFormat:nil];
        DLog(@"%@",itemDatas);
        if (itemDatas>0) {
            
           
            if ([pwfmdb pw_deleteAllDataFromTable:tableName]) {
//                 [pwfmdb pw_insertTable:tableName dicOrModelArray:itemArray];
            }
//            self.handbookArray = [[NSMutableArray alloc]initWithArray:itemArray];
            [self createUI];
        }
    }else{
        
        NSDictionary *dict = @{@"bucketPath":@"text",@"category":@"text",@"coverImageMobile":@"text",@"id":@"text",@"name":@"text",@"orderNum":@"integer",@"coverImageMobile":@"text"};
        if ([pwfmdb pw_createTable:tableName dicOrModel:dict primaryKey:@"pid"]) {
//        BOOL  is= [pwfmdb pw_insertTable:tableName dicOrModelArray:array];
        }
        self.handbookArray = [NSMutableArray arrayWithArray:array];
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
        NSError *error;
        PWDraggableModel *model = [[PWDraggableModel alloc]initWithDictionary:self.handbookArray[index] error:&error];
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
#pragma mark ========== PWDraggableItemDelegate ==========
- (void)dragButton:(PWDraggableItem *)dragButton dragButtons:(NSArray *)dragButtons startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
}
- (void)dragCenter:(CGPoint)point{
    
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
