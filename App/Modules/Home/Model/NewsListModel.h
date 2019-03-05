//
//  NewsListModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/2.
//  Copyright © 2019 hll. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, NewListCellType) {
    NewListCellTypeSingleImg  = 0,
    NewListCellTypText,
    NewListCellTypeFillImg,
};

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
@interface NewsListModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, assign) BOOL isStarred;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NewListCellType type;
@property (nonatomic, strong) NSString *favoID;

@property (nonatomic, assign) CGFloat cellHeight;
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithStickJsonDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithCollectionDictionary:(NSDictionary *)dictionary;
@end

