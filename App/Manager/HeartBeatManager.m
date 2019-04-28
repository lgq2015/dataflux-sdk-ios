//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "HeartBeatManager.h"

@interface HeartBeatManager ()

@end

@implementation HeartBeatManager {

}



- (void)sendHeartBeat {
    if (getXAuthToken) {
        NSDate *lastTime= getHeartBeatLastTime;
        if(!lastTime.isToday){
            DLog(@"heartBeat");
            [[PWHttpEngine sharedInstance] heartBeatWithCallBack:^(id o) {
                BaseReturnModel*data = (BaseReturnModel *)o;
                if(data.isSuccess){
                    setHeartBeatLastTime([NSDate date]);
                }
                
            }];
        }
    }
}
@end