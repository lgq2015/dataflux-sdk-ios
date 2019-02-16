//
//  RenderedTextModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"



@interface RenderedTextModel : JSONModel
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *suggestion;
@property (nonatomic, strong) NSString *highlight;
@end

