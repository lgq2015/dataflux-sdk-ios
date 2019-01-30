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

static NSUInteger kLineCount = 3;
static NSUInteger ItemHeight = 158;
@interface ThinkTankVC ()<PWDraggableItemDelegate>
@property (nonatomic, strong) NSMutableArray *handbookArray;
@end

@implementation ThinkTankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
}
- (void)loadDatas{
    self.handbookArray = [NSMutableArray new];
    [PWNetworking requsetHasTokenWithUrl:PW_handbookList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self.handbookArray addObjectsFromArray:content];
                [self createUI];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)createUI{
    self.mainScrollView.frame= CGRectMake(0, 0, kWidth, kHeight-kTopHeight-kTabBarHeight);
    NSUInteger backImgCount = self.handbookArray.count%3 == 0? self.handbookArray.count/3:self.handbookArray.count/3+1;
    self.mainScrollView.contentSize = CGSizeMake(0, backImgCount*ZOOM_SCALE(167)+25);
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *array = [NSMutableArray array];
    CGFloat width = ZOOM_SCALE(90);
    CGFloat kMargin = (kWidth-3*width)/4.00;
    CGFloat height = ZOOM_SCALE(127);
    //            [self createBackImgWithCount:backImgCount];
    for (NSInteger index = 0; index<self.handbookArray.count; index++) {
        NSError *error;
        PWDraggableModel *model = [[PWDraggableModel alloc]initWithDictionary:self.handbookArray[index] error:&error];
        model.orderNum = index;
        NSUInteger X = index % kLineCount;
        NSUInteger Y = index / kLineCount;
        PWDraggableItem *btn = [[PWDraggableItem alloc]init];
        btn.frame = CGRectMake(X * (width + kMargin) + kMargin, Y*ZOOM_SCALE(167)+ZOOM_SCALE(25), width, height);
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
#pragma mark ========== PWDraggableItemDelegate ==========
- (void)dragButton:(PWDraggableItem *)dragButton dragButtons:(NSArray *)dragButtons startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
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
