//
//  SearchIssueVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SearchIssueVC.h"
#import "SearchBarView.h"

@interface SearchIssueVC ()<SearchBarViewDelegate>
@property (nonatomic, strong) SearchBarView *searchBar;
@end

@implementation SearchIssueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.searchBar.placeHolder = NSLocalizedString(@"local.search", @"");
}
- (SearchBarView *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
        [self.view addSubview:_searchBar];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
-(void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchWithText:(NSString *)text{
    
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
