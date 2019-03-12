//
//  IssueSourceManger.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceManger.h"
#import "PWInfoSourceModel.h"
typedef void (^loadDataSuccess)(NSArray *datas);

@interface IssueSourceManger()
@property (nonatomic, strong) NSMutableArray *issueSourceList;
@property (nonatomic ,assign) NSInteger currentPage;
@property (nonatomic,copy) detectTimeStr strBlock;   //-> 回掉

@end
@implementation IssueSourceManger
+ (instancetype)sharedIssueSourceManger{
    static IssueSourceManger *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedManger = [[self alloc] init];
        [_sharedManger createData];
    });
    return _sharedManger;
}
- (void)createData{
    
}
- (void)downLoadAllIssueSourceList:(detectTimeStr)strblock{
    self.strBlock = strblock;
    self.currentPage =1;
    self.issueSourceList = [NSMutableArray new];
    NSDictionary *param = @{@"pageSize":@100,@"pageNumber":[NSNumber numberWithInteger:self.currentPage]};
   
    [self loadIssueSourceListWithParam:param completion:^(NSArray * _Nonnull datas) {
        [self dealDataWith:datas];
    }];
}

- (void)dealDataWith:(NSArray *)datas{
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSMutableArray *array = [NSMutableArray new];
    if (datas.count > 0) {
        [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PWInfoSourceModel *model = [[PWInfoSourceModel alloc]initWithJsonDictionary:obj];
            [array addObject:model];
        }];
        if ([pwfmdb pw_isExistTable:PW_IssueTabName]) {
            [pwfmdb pw_deleteAllDataFromTable:PW_IssueTabName];
          BOOL issuccess = [pwfmdb pw_insertTable:PW_IssueTabName dicOrModelArray:datas];
        }else{
            NSDictionary *dict = @{@"provider":@"TEXT",@"name":@"TEXT",@"teamId":@"TEXT",@"scanCheckStatus":@"TEXT",@"provider":@"TEXT",@"teamId":@"TEXT",@"updateTime":@"TEXT",@"id":@"TEXT",@"credentialJSON":@"TEXT"};
        BOOL isCreate = [pwfmdb pw_createTable:PW_IssueTabName dicOrModel:dict primaryKey:@"PWId"];
            if (isCreate) {
         BOOL issuccess =   [pwfmdb pw_insertTable:PW_IssueTabName dicOrModelArray:datas];
              
            }
    }
           [self getLastDetectionTimeNow];
        
    }else{
        if ([pwfmdb pw_isExistTable:PW_IssueTabName]) {
            [pwfmdb pw_deleteAllDataFromTable:PW_IssueTabName];
        }
        self.strBlock ? self.strBlock(@"尚未进行检测"):nil;
    }
}
- (NSString *)getLastDetectionTime{
   //判断时间间隔
    
    //小于30s
    return [self getLastDetectionTimeNow];
}
- (NSString *)getLastDetectionTimeNow{
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *whereFormat =@"order by updateTime desc";
    NSDictionary *dict = @{@"provider":@"TEXT",@"name":@"TEXT",@"teamId":@"TEXT",@"scanCheckStatus":@"TEXT",@"provider":@"TEXT",@"teamId":@"TEXT",@"updateTime":@"TEXT",@"id":@"TEXT",@"credentialJSON":@"TEXT"};
    NSArray *array = [pwfmdb pw_lookupTable:PW_IssueTabName dicOrModel:dict whereFormat:whereFormat];
    NSString *time = array[0][@"updateTime"];
    NSString *local =  [NSString getLocalDateFormateUTCDate:time formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    self.strBlock ? self.strBlock([NSString compareCurrentTime:local]):nil;
    return [NSString compareCurrentTime:local];
}
- (void)loadIssueSourceListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion{
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count>0) {
                [self.issueSourceList addObjectsFromArray:data];
                NSDictionary *pageInfo = content[@"pageInfo"];
                long totalCount =[pageInfo longValueForKey:@"totalCount" default:0];
               
                if (totalCount>self.issueSourceList.count) {
                    self.currentPage ++;
                     NSDictionary *params =@{@"pageSize":@100,@"pageNumber":[NSNumber numberWithInteger:self.currentPage]};
                    [self loadNextIssueSourceListWithParam:params completion:^(NSArray * _Nonnull datas) {
                        completion(datas);
                    }];
                }else{
                    completion(self.issueSourceList);
                }
              
            }else{
                completion(self.issueSourceList);
            }
        }else{
            
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}
- (NSInteger)getBasicIssueSourceCount{
    PWFMDB *pwfmdb = [PWFMDB shareDatabase];
    NSString *whereFormat =@"where provider = 'aliyun' or  provider = 'aws' or provider = 'qcloud' or provider= 'ucloud' ";
     NSDictionary *dict = @{@"provider":@"TEXT",@"name":@"TEXT",@"teamId":@"TEXT",@"scanCheckStatus":@"TEXT",@"provider":@"TEXT",@"teamId":@"TEXT",@"updateTime":@"TEXT",@"id":@"TEXT",@"credentialJSON":@"TEXT"};
    NSArray *array = [pwfmdb pw_lookupTable:PW_IssueTabName dicOrModel:dict whereFormat:whereFormat];
    return  array.count;
}
- (void)loadNextIssueSourceListWithParam:(NSDictionary *)param completion:(loadDataSuccess)completion{
    [self loadIssueSourceListWithParam:param completion:^(NSArray * _Nonnull datas) {
        completion(datas);
    }];
}
@end
