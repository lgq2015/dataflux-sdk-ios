//
// Created by Brandon on 2019-04-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZhugeIOBaseEventHelper : NSObject

@property (strong, nonatomic) NSString * category;
@property(strong, nonatomic) NSMutableDictionary *data;



- (ZhugeIOBaseEventHelper *)event:(NSString *)event;

- (ZhugeIOBaseEventHelper *)scene:(NSString *)scene;

- (ZhugeIOBaseEventHelper*)result:(NSString *)result;

- (void)track;

- (void)startTrack;

- (void)endTrack;
@end