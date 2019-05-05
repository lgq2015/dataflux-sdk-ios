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
    if([model.type isEqualToString:@"singleAccount"]){
        _teamName.text = @"我的团队";
    }else{
        _teamName.text = model.name;
    }
    NSLog(@"zhangtao----%@----%@",userManager.teamModel.teamID,userManager.teamModel);
    //当前团队
    if ([userManager.teamModel.teamID isEqualToString:model.teamID]){
        _selectedImage.hidden = NO;
        _teamName.textColor = [UIColor colorWithHexString:@"#2A7AF7"];
        _numLab.hidden = YES;
    }else{
        _selectedImage.hidden = YES;
        _teamName.textColor = [UIColor colorWithHexString:@"#140F26"];
        _numLab.hidden = NO;
        if (model.issueCount == nil || [model.issueCount isEqualToString:@""]){
            _numLab.text = @"当前情报：0";
        }else{
            _numLab.text = [NSString stringWithFormat:@"情报： %@",model.issueCount];
        }
    }
    _callLab.hidden = YES;
}

@end
