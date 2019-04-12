//
//  PWInfoBoard.h
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/9/3.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PWInfoBoard : UIView
-(instancetype)initWithFrame:(CGRect)frame paramsDic:(NSDictionary*)paramsDic;
- (void)openModel:(NSDictionary *)paramsDict;
- (void)updateItem:(NSDictionary *)paramsDict;
- (void)updateTitle:(NSDictionary *)paramsDict;
@end
