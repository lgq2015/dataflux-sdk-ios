//
//  NewsWebView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NewsWebView.h"
#import "WebItemView.h"
@interface NewsWebView ()
@property (nonatomic, strong) UIView *dropdownView;
@property (nonatomic, strong) WebItemView *itemView;
@end

@implementation NewsWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    UIView *segeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 87, 32)];
    segeView.layer.cornerRadius = 16;
    segeView.layer.borderWidth = 1;
    segeView.layer.borderColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0, 4, 1, 24)];
    line.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08];
    CGPoint center = line.center;
    center.x = segeView.centerX;
    line.center = center;
    [segeView addSubview:line];
    UIButton *share = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 32, 32)];
    [share setImage:[UIImage imageNamed:@"web_more"] forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"web_more"] forState:UIControlStateHighlighted];
    [segeView addSubview:share];
    [share addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(46, 0, 32, 32)];
    [close setImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateNormal];
    [close setImage:[UIImage imageNamed:@"web_close"] forState:UIControlStateHighlighted];
    [close addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [segeView addSubview:close];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:segeView];
    self.navigationItem.rightBarButtonItem = item;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webview = webView;
    DLog(@"%@",self.webUrl);
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
    [self.view addSubview:self.webview];
    
}
- (void)shareBtnClick{
    [self.itemView showInView:[UIApplication sharedApplication].keyWindow];
    self.itemView.itemClick = ^(NSInteger tag){
       
    };
    
  
}
- (void)closeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (WebItemView *)itemView{
    if (!_itemView) {
        _itemView = [[WebItemView alloc]init];
    }
    return _itemView;
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
