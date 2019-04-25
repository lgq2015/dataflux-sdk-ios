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



@end
