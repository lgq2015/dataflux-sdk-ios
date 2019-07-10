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
#import "IssueLogModel.h"
#import "IssueSourceManger.h"
#import "IssueChatDataManager.h"
#import "IssueLogListModel.h"
#import "IssueModel.h"

#define ON_EVENT_ISSUE_UPDATE @"socketio.issueUpdate"
#define ON_EVENT_ISSUE_SOURCE_UPDATE @"socketio.issueSourceUpdate"
#define ON_EVENT_ISSUE_LOG_ADD @"socketio.issueLogAdd"
#define ON_EVENT_RECORD_Last_ReadSeq @"socketio.recordLastReadSeq"

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
@property(assign, nonatomic) BOOL isAuthed;
@property (assign, nonatomic) BOOL isFetchingComplete;



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

- (void)connect:(BOOL)force {


    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSocketConnecting object:nil];

    DLog(@"try to connecting... ,force:%d",force)

    if (![self isConnect]||force) {
        [self shutDown];
        [self initSocket];
    } else{
        DLog(@"already connected")
    }
}

/**
 * 是否链接
 * @return
 */
- (BOOL)isConnect {
    if(self.socket){
        return self.socket.status == SocketIOStatusConnected&&_isAuthed&&_isFetchingComplete;
    } else{
        return NO;
    }
}

-(void)forceRestart{
    if (getXAuthToken) {
        [self connect:YES];
    }
}

//判断是否需要重新启用
- (void)checkForRestart {
    if (getXAuthToken) {
        [self connect:NO];
    }

}

- (void)initSocket {
    NSURL *url = [[NSURL alloc] initWithString:API_CORE_STONE];

    NSMutableDictionary *opt = [@{
            @"log": @NO,//是否开启LOG
            @"handleQueue": socket_message_queue(),
            @"secure": @(IS_HTTPS),
            @"forcePolling": @YES,
            @"forceWebsockets": @YES,
            @"reconnects": @NO
    } mutableCopy];

    self.manager = [[SocketManager alloc] initWithSocketURL:url config:opt];
    self.socket = [self.manager defaultSocket];

    [self.socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {

        if (data.count > 0) {
            DLog(@"socket connected%@", data[0]);
            if (getXAuthToken) {
                [[self.socket emitWithAck:@"auth" with:@[getXAuthToken]] timingOutAfter:0 callback:^(NSArray *data) {
                    if (data.count > 0) {
                        DLog(@"emitWithAck%@", data);
                        NSString *jsonString = data[0];
                        NSDictionary *dic = [jsonString jsonValueDecoded];
                        NSInteger code = [dic integerValueForKey:@"error" default:0];
                        if (code == 200) {
                            _isAuthed = YES;
//                            [[IssueListManger sharedIssueListManger] fetchIssueList:NO];
                        } else{
                            _isAuthed  =NO;
                        }

                    }
                }];
            }
        }
    }];

    [self.socket on:@"connectError" callback:^(NSArray *data, SocketAckEmitter *ack) {
        if (data.count > 0) {
            DLog(@"socket connectError%@", data[0]);
            [self performSelector:@selector(retryConnect) afterDelay:10];
        }
    }];

    [self.socket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        if (data.count > 0) {
            DLog(@"socket disconnect%@", data[0]);

            [self performSelector:@selector(retryConnect) afterDelay:10];
        }
    }];

    [self.socket on:ON_EVENT_ISSUE_UPDATE callback:^(NSArray *data, SocketAckEmitter *ack) {
        if (data.count > 0) {
            DLog(ON_EVENT_ISSUE_UPDATE
                    " = %@", data);
            NSString *jsonString = data[0];
            NSDictionary *dic = [jsonString jsonValueDecoded];
            NSArray *addedIssues = PWSafeArrayVal(dic, @"addedIssues");
            if (addedIssues.count>0) {
                IssueModel *model = [[IssueModel alloc]initWithDictionary:addedIssues[0]];
                if ( [model.origin isEqualToString:@"user"] ) {
                    NSDictionary *originInfoJSON = [model.originInfoJSONStr jsonValueDecoded];
                    NSString *accountId = [originInfoJSON stringValueForKey:@"accountId" default:@""];
                    if (![accountId isEqualToString:userManager.curUserInfo.userID]) {
                   dispatch_async_on_main_queue(^{
                        [kNotificationCenter
                         postNotificationName:KNotificationNewIssue
                         object:nil
                         userInfo:@{@"types": @[]}];
                   
                                                
                            });
                    }}
            }
            
           
            [[IssueListManger sharedIssueListManger] fetchIssueList:NO];
        }

    }];

    [self.socket on:ON_EVENT_ISSUE_SOURCE_UPDATE callback:^(NSArray *data, SocketAckEmitter *ack) {
        if (data.count > 0) {
            DLog(ON_EVENT_ISSUE_SOURCE_UPDATE" = %@", data);
            NSString *jsonString = data[0];
            NSDictionary *dic = [jsonString jsonValueDecoded];
            NSArray* arr= [dic mutableArrayValueForKey:@"deletedIssueSourceIds"];
            [[IssueListManger sharedIssueListManger] deleteIssueWithIssueSourceID:arr];
            [[IssueSourceManger sharedIssueSourceManger] deleteIssueSourceById:arr];


        }

    }];
//    [self.socket on:ON_EVENT_RECORD_Last_ReadSeq callback:^(NSArray *data, SocketAckEmitter *ack) {
//        if (data.count > 0) {
//            DLog(ON_EVENT_RECORD_Last_ReadSeq" = %@", data);
//            NSString *jsonString = data[0];
//            NSDictionary *dic = [jsonString jsonValueDecoded];
//            [kNotificationCenter
//             postNotificationName:KNotificationRecordLastReadSeq
//             object:nil
//             userInfo:dic];
//        }
//
//    }];
    [self.socket on:ON_EVENT_ISSUE_LOG_ADD callback:^(NSArray *data, SocketAckEmitter *ack) {
        DLog(ON_EVENT_ISSUE_LOG_ADD
                " = %@", data);
        if (data.count > 0) {
            NSString *jsonString = data[0];
            NSDictionary *dic = [jsonString jsonValueDecoded];

            IssueLogModel *issueLogModel = [[IssueLogModel new] initWithDictionary:dic];

            NSArray *array =
                    @[@"updateExpertGroups",
                            @"exitExpertGroups",
                            @"call",
                            @"comment"];

            //过滤脏数据
            if ([array containsObject:issueLogModel.subType]) {

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    IssueModel * issueModel = [[IssueListManger sharedIssueListManger] getIssueDataByData:issueLogModel.issueId];

                    BOOL endCompleteData = [[IssueListManger sharedIssueListManger] checkIssueLastStatus:issueModel.issueId];

                    issueLogModel.dataCheckFlag = !endCompleteData||!_isFetchingComplete;

                    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:issueLogModel.issueId data:issueLogModel deleteCache:NO];

                    if(issueModel){
                        [[IssueListManger sharedIssueListManger] updateIssueLogInIssue:issueModel.issueId data:issueLogModel];


                    }
                    DLog(@"sync notification view")
                    dispatch_async_on_main_queue(^{

//                        [kNotificationCenter postNotificationName:KNotificationInfoBoardDatasUpdate object:nil
//                                            userInfo:nil];

                        [kNotificationCenter postNotificationName:KNotificationUpdateIssueList object:nil
                                            userInfo:@{@"updateView":@(YES)}];

                        [kNotificationCenter postNotificationName:KNotificationUpdateIssueDetail object:nil
                                                         userInfo:@{@"updateView":@(YES)}];

                        [kNotificationCenter
                                postNotificationName:KNotificationNewIssueLog
                                              object:nil
                                            userInfo:dic];

                    });

                });


            }

        }

    }];

    [self.socket connect];
}

/**
 * 尝试获取讨论消息内容
 */
-(void)tryFetchIssueLog{
    _isFetchingComplete = NO;
    [[IssueListManger sharedIssueListManger] fetchIssueList:^(BaseReturnModel *model)  {
        if(model.isSuccess){
            [[IssueChatDataManager sharedInstance] fetchLatestChatIssueLog:nil
                                                                  callBack:^(BaseReturnModel *issueLogListModel) {

                if(issueLogListModel.isSuccess){
                    _isFetchingComplete = YES;
                    [kNotificationCenter
                            postNotificationName:KNotificationFetchComplete
                                          object:nil];

                } else{
                    if([model.errorCode isEqualToString: ERROR_CODE_LOCAL_IS_FETCHING]) {

                    } else{
                        [self performSelector:@selector(tryFetchIssueLog) afterDelay:10];
                    }

                }

            }];


        } else{
            if([model.errorCode isEqualToString: ERROR_CODE_LOCAL_IS_FETCHING]) {

            } else{
                [self performSelector:@selector(tryFetchIssueLog) afterDelay:10];
            }

        }

    } getAllDatas:NO];

}

- (void)retryConnect {

    if ([YYReachability new].isReachable) {
        if (self.socket.status != SocketIOStatusConnecting) {
            [self checkForRestart];
        }
    } else{
        DLog(@"network not available");
    }
}

- (void)shutDown {
     _isFetchingComplete = NO;
    [self.socket removeAllHandlers];
    [self.socket disconnect];
    self.socket = nil;

}
@end
