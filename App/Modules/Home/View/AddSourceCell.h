//
//  AddSourceCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSourceCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) void(^itemClick)(NSInteger index);

@end


