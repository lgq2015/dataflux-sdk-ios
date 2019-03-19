//
//  SearchVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SearchVC.h"
#import "HistoryTableView.h"
#import "HandbookModel.h"
#import "HandbookCell.h"
#import "NewsWebView.h"
@interface SearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


/**
 * 获取输入的数据
 */
@property (copy, nonatomic) NSString *inputText;

@property (nonatomic, strong) HistoryTableView *historytableView;
@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) NSMutableArray *historyData;
@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBar];
    [self createUI];
}
- (void)initSearchBar
{
    self.searchBar.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.historytableView = [[HistoryTableView alloc]initWithFrame:CGRectMake(0, kTopHeight, kWidth, kHeight-kTopHeight)];
    WeakSelf;
    self.historytableView.searchItem =^(NSString *search){
        [weakSelf.searchTF resignFirstResponder];
        weakSelf.searchTF.text = search;
        [weakSelf saveHistoryData:search];
        [weakSelf searchHandBookWith:search];
    };
    [self.view addSubview:self.historytableView];
    self.searchTF.placeholder = self.placeHolder;
}
- (void)createUI{
    self.historyData = [NSMutableArray new];
    NSArray * myArray = getPWhistorySearch;
    [self.historyData addObjectsFromArray:myArray];
    self.tableView.frame = CGRectMake(0, kTopHeight, kWidth, kHeight-kTopHeight);
    self.tableView.rowHeight = ZOOM_SCALE(46)+Interval(82);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[HandbookCell class] forCellReuseIdentifier:@"HandbookCell"];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.searchTF becomeFirstResponder];
    if (self.isLocal) {
        [[self.searchTF rac_textSignal] subscribeNext:^(NSString *x) {
            if (x.length>0) {
            [self searchLocalDataWith:x];
            }
        }];
    }
}
-(void)searchLocalDataWith:(NSString *)text{
    self.dataSource = [NSMutableArray new];
    NSString *inputStr = [text lowercaseString];
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    [self.totalData enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"title"];
        NSString *lowStr=[title lowercaseString];
        if (lowStr != nil &&[lowStr rangeOfString:inputStr].location != NSNotFound) {
            [self.dataSource addObject:obj];
        }
    }];
    if (self.dataSource.count>0) {
        [self hideNoSearchView];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        self.tableView.tableFooterView = self.footView;
    }else{
        [self showNoSearchView];
    }
   
}
- (UIView *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
        [self.view addSubview:_searchBar];
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        [_searchBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.left.right.mas_equalTo(_searchBar);
            make.height.offset(1);
        }];
       UIView * searchView = [[UIView alloc]initWithFrame:CGRectZero];
        searchView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        searchView.layer.cornerRadius = 4.0f;
        [_searchBar addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchBar).offset(16);
            make.width.offset(ZOOM_SCALE(290));
            make.height.offset(36);
            make.bottom.mas_equalTo(_searchBar).offset(-Interval(3));
        }];
        UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:@"取消"];
        [cancle addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cancle setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_searchBar addSubview:cancle];
        [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(searchView);
            make.right.mas_equalTo(self.view).offset(-Interval(14));
            make.height.offset(ZOOM_SCALE(22));
        }];
       UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
        [icon addGestureRecognizer:tap];
        [_searchBar addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(searchView);
            make.left.mas_equalTo(searchView).offset(5);
            make.width.height.offset(30);
        }];
        [_searchBar addSubview:self.searchTF];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(3);
            make.centerY.mas_equalTo(icon);
            make.right.mas_equalTo(searchView);
            make.height.mas_equalTo(searchView);
        }];
    }
    return _searchBar;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:MediumFONT(14)];
        _searchTF.delegate = self;
    }
    return  _searchTF;
}
- (void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchClick{
    if (self.isLocal) {
        [self searchLocalDataWith:self.searchTF.text];
    }else{
        [self searchHandBookWith:self.searchTF.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField.text.length != 0){
        [self saveHistoryData:textField.text];
        [self searchHandBookWith:textField.text];
    }
    return YES;
}
- (void)saveHistoryData:(NSString *)text{

    [self.historyData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:text]) {
            [self.historyData removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.historyData insertObject:text atIndex:0];
    if (self.historyData.count>10) {
        [self.historyData removeObjectAtIndex:10];
    }
    setPWhistorySearch(self.historyData);
}
- (void)searchHandBookWith:(NSString *)text{
    if (self.isLocal) {
        [self searchLocalDataWith:text];
    }else{
    self.historytableView.hidden = YES;
    [SVProgressHUD show];
    NSDictionary *param = @{@"q":text,@"orderBy":@"desc"};
    [PWNetworking requsetHasTokenWithUrl:PW_articleSearch withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self hideNoSearchView];
                self.dataSource = [NSMutableArray new];
                [self.dataSource addObjectsFromArray:content];
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                self.tableView.tableFooterView = self.footView;
            }else{
                [self showNoSearchView];
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    }
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HandbookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HandbookCell"];
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.row] error:&error];
    NewsWebView *webview = [[NewsWebView alloc]initWithTitle:model.title andURLString:PW_handbookUrl(model.articleId)];
    webview.handbookModel = model;
    [self.navigationController pushViewController:webview animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
