//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOBaseEventHelper.h"

@interface ZhugeIOBaseEventHelper()

@property (strong, nonatomic) NSDictionary * data;
@property (strong, nonatomic) NSString * event;

@end


@implementation ZhugeIOBaseEventHelper {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSDictionary new];
    }

    return self;
}

-(id)event:(NSString *)event{
    _event = event;
    return self;
}

-(void)track{
    if(_data.allKeys.count>0){
        
    }
}




@end