//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZhugeIOBaseEventHelper : NSObject

@property (strong, nonatomic) NSString * category;
@property(strong, nonatomic) NSMutableDictionary *data;



- (void)event:(NSString *)event;

- (void)scene:(NSString *)scene;

- (void)result:(NSString *)result;

- (void)track;

- (void)startTrack;

- (void)endTrack;
@end