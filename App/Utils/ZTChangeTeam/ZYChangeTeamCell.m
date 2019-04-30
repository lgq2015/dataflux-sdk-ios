//
//  ZYChangeTeamCell.m
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZYChangeTeamCell.h"
@interface ZYChangeTeamCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightCons;

@end
@implementation ZYChangeTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.teamName.font = RegularFONT(16);
    self.callLab.font = RegularFONT(16);
    self.numLab.font = RegularFONT(15);
    self.imgWidthCons.constant = ZOOM_SCALE(19);
    self.imgHeightCons.constant = ZOOM_SCALE(19);
}

- (void)setModel:(TeamInfoModel *)model{
    _model = model;
    _teamName.text = model.name;
    //当前团队
    if ([userManager.teamModel.teamID isEqualToString:model.teamID]){
        _selectedImage.hidden = NO;
        _teamName.textColor = [UIColor colorWithHexString:@"#2A7AF7"];
        _numLab.hidden = YES;
    }else{
        _selectedImage.hidden = YES;
        _teamName.textColor = [UIColor colorWithHexString:@"#140F26"];
        _numLab.hidden = NO;
        _numLab.text = @"当前情报：0";
    }
    _callLab.hidden = YES;
}

@end
