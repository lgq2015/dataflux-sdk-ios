//
//  ZYChangeTeamCell.h
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYChangeTeamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *callLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic, strong)TeamInfoModel *model;
@end

NS_ASSUME_NONNULL_END
