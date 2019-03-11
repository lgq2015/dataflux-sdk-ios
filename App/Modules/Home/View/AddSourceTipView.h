//
//  AddSourceTipView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,AddSourceTipType){
    AddSourceTipTypeSuccess,
    AddSourceTipTypeTeam,
    AddSourceTipTypePersonal,
};

@interface AddSourceTipView : UIView
@property (nonatomic, copy) void(^btnClick)(void);

-(instancetype)initWithFrame:(CGRect)frame type:(AddSourceTipType)type;

@end


