//
// Created by Brandon on 2019-03-30.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "LaunchVC.h"


@implementation LaunchVC {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isHidenNaviBar = YES;

    UIImage *image;

    if ([getTeamState isEqualToString:PW_isTeam]) {
        image = [UIImage imageNamed:@"pw_launch_bg_group"];
    } else {
        image = [UIImage imageNamed:@"pw_launch_bg_personal"];
    }

    UIImageView *launchImg = [[UIImageView alloc] initWithImage:image];


    launchImg.contentMode = UIViewContentModeScaleAspectFit;


    [self.view addSubview:launchImg];

    [launchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(self.view);
        make.width.offset(320);
    }];


    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pw_launch_ic_logo"]];

    logo.contentMode = UIViewContentModeScaleAspectFit;

    [self.view addSubview:logo];

    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-80);
        make.centerX.mas_equalTo(self.view);
        make.height.offset(55);

    }];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = NSLocalizedString(@"Lunch.Title", @"");

    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-50);
        make.centerX.mas_equalTo(self.view);

    }];
}


@end
