//
//  NewsListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NewsListModel.h"
/*
 "id": 15,
 "topicId": 1,
 "topic": {
 "id": 1,
 "title": "板块一",
 "key": "topic-1",
 "enabled": true
 },
 "accountId": "acnt-1bd71821-8994-4087-ad0a-5cdb8cc25c24",
 "account": {
 "id": "acnt-1bd71821-8994-4087-ad0a-5cdb8cc25c24",
 "name": "张三",
 "isDisabled": false
 },
 "title": "主题",
 "content": "正文",
 "readCount": 1,
 "commentCount": 0,
 "collectCount": 0,
 "likeCount": 0,
 "repostCount": 0,
 "isStarred": true,
 "isSticky": false,
 "isUserLike": false,
 "createdAt": "2019-01-22T09:54:29Z",
 "updatedAt": "2019-01-26T09:05:53Z"
 
 */
/*
 {
 "createTime": "2019-02-16T10:49:05+00:00",
 "id": "rcmd-5frTdL3MUgANvWPYiLBECm",
 "onShelvesTime": "2019-02-16T10:49:11+00:00",
 "picUrl": "",
 "position": 1,
 "summary": "",
 "title": "推荐位5",
 "url": "http://localhost:8080/recommend/add"
 },
 */
/*
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, strong) NSString *subtitle;
 @property (nonatomic, strong) NSString *source;
 @property (nonatomic, strong) NSString *createdAt;
 @property (nonatomic, strong) NSString *updatedAt;
 @property (nonatomic, assign) BOOL isStarred;
 @property (nonatomic, strong) NSString *imageUrl;
 @property (nonatomic, assign) NSInteger type;
 */
@implementation NewsListModel
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithJson:dictionary];
    }
    return self;
}
-(instancetype)initWithStickJsonDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        [self setValueWithStickJson:dictionary];
    }
    return self;
}
- (void)setValueWithJson:(NSDictionary *)dict{
    self.title = [dict stringValueForKey:@"title" default:@""];
    self.updatedAt = [NSString getLocalDateFormateUTCDate:[dict stringValueForKey:@"updatedAt" default:@""] formatter:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    self.subtitle = [dict stringValueForKey:@"content" default:@""];
    self.imageUrl = [dict stringValueForKey:@"picUrl" default:@""];
    NSString *newid = [dict stringValueForKey:@"id" default:@""];
    if (newid.length>0) {
        self.url = PW_articleDetails(newid);
    }else{
        self.url = @"";
    }
    if (![self.imageUrl isEqualToString:@""]) {
        self.type = NewListCellTypeSingleImg;
    }else{
        self.type = NewListCellTypText;
    }
    NSDictionary *topic=dict[@"topic"];
    self.topic =[topic stringValueForKey:@"title" default:@""];
    self.isStarred = NO;
}
- (void)setValueWithStickJson:(NSDictionary *)dict{
    self.title = [dict stringValueForKey:@"title" default:@""];
    NSString *time = [dict stringValueForKey:@"onShelvesTime" default:@""];
    if(time.length>19){
        time = [time substringToIndex:19];
        self.updatedAt =[NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm:ss"];
    }else{
        self.updatedAt = time;
    }
    self.subtitle = [dict stringValueForKey:@"summary" default:@""];
    self.imageUrl = [dict stringValueForKey:@"picUrl" default:@""];
    self.url = [dict stringValueForKey:@"url" default:@""];
    if (![self.imageUrl isEqualToString:@""]) {
        self.type = NewListCellTypeSingleImg;
        self.cellHeight = ZOOM_SCALE(112)+Interval(30);
    }else{
        self.type = NewListCellTypText;
    }
    self.isStarred = YES;
}
@end
