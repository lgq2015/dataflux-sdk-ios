//
//  PWSocketManager.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWSocketManager.h"
#import "IssueListManger.h"
#import "YYReachability.h"

#define ON_EVENT_ISSUE_UPDATE @"socketio.issueUpdate"
#define ON_EVENT_ISSUE_LOG_ADD @"socketio.issueLogAdd"

static dispatch_queue_t socket_message_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.profwang.socketio.handler.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@interface PWSocketManager ()
@property(strong, nonatomic) SocketManager *manager;
@property(strong, nonatomic) SocketIOClient *socket;


@end

@implementation PWSocketManager
+ (instancetype)sharedPWSocketManager {
    static PWSocketManager *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];

    });
    return _sharedManger;
}

- (void)connect {

    
    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationRefetchIssChatDatas object:nil];

    if (!self.socket || self.socket.status == SocketIOStatusNotConnected
        || self.socket.status == SocketIOStatusDisconnected) {
        [self shutDown];
        [self initSocket];
    }
}

/**
 * 是否链接
 * @return
 */
-(BOOL)isConnect{
    return self.socket.status==SocketIOStatusConnected;
}

//判断是否需要重新启用
- (void)checkForRestart {
    if (!getXAuthToken) {
        [self connect];
    }

}

- (void)initSocket {
    NSURL *url = [[NSURL alloc] initWithString:API_CORE_STONE];

    NSMutableDictionary *opt = [@{
            @"log": @NO,//是否开启LOG
            @"handleQueue": socket_message_queue(),
            @"secure": @(HTTPS),
            @"forcePolling": @YES,
            @"forceWebsockets": @YES,
            @"reconnects": @NO
    } mutableCopy];

    self.manager = [[SocketManager alloc] initWithSocketURL:url config:opt];
    self.socket = [self.manager defaultSocket];

    [self.socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(@"socket connected%@", data[0]);
        [[self.socket emitWithAck:@"auth" with:@[getXAuthToken]] timingOutAfter:0 callback:^(NSArray *data) {
            DLog(@"emitWithAck%@", data);
        }];
    }];

    [self.socket on:@"connectError" callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(@"socket connectError%@", data[0]);
        [self performSelector:@selector(retryConnect) afterDelay:10];

    }];

    [self.socket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(@"socket disconnect%@", data[0]);

        [self performSelector:@selector(retryConnect) afterDelay:10];

    }];

    [self.socket on:ON_EVENT_ISSUE_UPDATE callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(ON_EVENT_ISSUE_UPDATE
                " = %@", data);
        [[IssueListManger sharedIssueListManger] newIssueNeedUpdate];
    }];
    [self.socket on:@"socketio.issueLogAdd" callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(ON_EVENT_ISSUE_LOG_ADD
                " = %@", data);
    }];

    [self.socket connect];
}

- (void)retryConnect {

    if ([YYReachability new].isReachable) {
        [self checkForRestart];
    }
}

- (void)shutDown {
    [self.socket off:ON_EVENT_ISSUE_UPDATE];
    [self.socket off:ON_EVENT_ISSUE_LOG_ADD];
    [self.socket disconnect];
    self.socket = nil;

}
@end
