//
//  PWSocketManager.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWSocketManager.h"
#import "IssueListManger.h"
@interface PWSocketManager()
@property (strong, nonatomic) SocketManager* manager;
@property (strong, nonatomic) SocketIOClient *socket;


@end
@implementation PWSocketManager
+ (instancetype)sharedPWSocketManager{
    static PWSocketManager *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        
    });
    return _sharedManger;
}
- (void)connecSuccess:(void(^)(void))success fail:(void(^)(void))fail{
    NSURL* url = [[NSURL alloc] initWithString:API_CORE_STONE];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO, @"compress": @NO,@"forceWebsockets":@YES}];
    self.socket = [self.manager defaultSocket];
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        DLog(@"socket connected %@",data);
    }];
    //监听是否连接上服务器，正确连接走后面的回调
    [self.socket on:@"hello" callback:^(NSArray* data, SocketAckEmitter* ack) {
        DLog(@"服务器连接成功加入房间:%@",data);
        [[self.socket emitWithAck:@"auth" with:@[getXAuthToken]] timingOutAfter:0 callback:^(NSArray * data) {
          NSDictionary *dict = [data[0] jsonValueDecoded];
            DLog(@"auth = %@",dict);
        }];
    }];
   
    [self.socket on:@"socketio.newMessage" callback:^(NSArray * data, SocketAckEmitter * ack) {
        DLog(@"newMessage = %@",data);
    }];
    [self.socket on:@"socketio.issueUpdate" callback:^(NSArray * data, SocketAckEmitter * ack) {
        DLog(@"newissueUpdate = %@",data);
        NSArray *dict = [data[0] jsonValueDecoded];
        [[IssueListManger sharedIssueListManger] newIssueNeedUpdate];
    }];
    [self.socket on:@"socketio.issueLogAdd" callback:^(NSArray * data, SocketAckEmitter * ack) {
        DLog(@"newissueLogAdd = %@",data);
    }];
    
    [self.socket connect];

}
@end
