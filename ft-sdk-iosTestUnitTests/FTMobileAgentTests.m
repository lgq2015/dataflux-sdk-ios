//
//  ft_sdk_iosTestUnitTests.m
//  ft-sdk-iosTestUnitTests
//
//  Created by 胡蕾蕾 on 2019/12/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FTMobileAgent/FTMobileAgent.h>
#import <ZYDataBase/ZYTrackerEventDBTool.h>
#import <FTMobileAgent/FTMobileAgent.h>
#import <ZYBaseInfoHander.h>
#import <RecordModel.h>
#import <FTLocationManager.h>
#import "AppDelegate.h"
#import <ZYUploadTool.h>
@interface FTMobileAgentTests : XCTestCase
@property (nonatomic, strong) FTMobileConfig *config;
@end


@implementation FTMobileAgentTests

- (void)setUp {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.config = appDelegate.config;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
  
}

- (void)testTrackMethod {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSInteger count =  [[ZYTrackerEventDBTool sharedManger] getDatasCount];
    [[FTMobileAgent sharedInstance] track:@"testTrack" values:@{@"event":@"testTrack"}];
    NSArray *all  = [[ZYTrackerEventDBTool sharedManger] getAllDatas];
    NSMutableDictionary *opdata =  [NSMutableDictionary dictionaryWithDictionary:@{
          @"field":@"testTrack",
          @"values":@{@"event":@"testTrack"}
        }];
    NSDictionary *datas =@{
                        @"op":@"cstm",
                        @"opdata":opdata,
                        };
   ;
    RecordModel *model =  [all lastObject];
    NSString *str = [ZYBaseInfoHander convertToJsonData:datas];
    XCTAssertTrue([model.data isEqualToString:str]);
    NSInteger newCount =  [[ZYTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount-count==1);

}
- (void)testLocation{
    FTLocationManager *location = [[FTLocationManager alloc]init];
    location.updateLocationBlock = ^(NSString * _Nonnull location, NSError * _Nonnull error) {
        XCTAssertTrue([location isEqualToString:@"上海市"]);

    };
}

- (void)testTags{
    dispatch_queue_t queue = dispatch_queue_create("net.test.testQueue", DISPATCH_QUEUE_SERIAL);
       __block NSString *tag;
      ZYUploadTool *tool = [[ZYUploadTool alloc]initWithConfig:self.config];

       dispatch_async(queue, ^{
           [NSThread sleepForTimeInterval:1.0f];
             tag= [tool performSelector:@selector(getBasicData)];
    if(self.config.monitorInfoType & FTMonitorInfoTypeLocation || self.config.monitorInfoType & FTMonitorInfoTypeAll){
        XCTAssertTrue([tag rangeOfString:@"location_city"].location != NSNotFound);
    }
    if(self.config.monitorInfoType & FTMonitorInfoTypeCamera || self.config.monitorInfoType & FTMonitorInfoTypeAll){
         XCTAssertTrue([tag rangeOfString:@"camera_front_px"].location != NSNotFound);
     }
    if(self.config.monitorInfoType & FTMonitorInfoTypeNetwork || self.config.monitorInfoType & FTMonitorInfoTypeAll){
        XCTAssertTrue([tag rangeOfString:@"network_type"].location != NSNotFound);
    }
    if(self.config.monitorInfoType & FTMonitorInfoTypeCpu || self.config.monitorInfoType & FTMonitorInfoTypeAll){
        XCTAssertTrue([tag rangeOfString:@"cpu_no"].location != NSNotFound);
    }
    if(self.config.monitorInfoType & FTMonitorInfoTypeMemory || self.config.monitorInfoType & FTMonitorInfoTypeAll){
              XCTAssertTrue([tag rangeOfString:@"memory_total"].location != NSNotFound);
      }
    if(self.config.monitorInfoType & FTMonitorInfoTypeBattery || self.config.monitorInfoType & FTMonitorInfoTypeAll){
            XCTAssertTrue([tag rangeOfString:@"battery_use"].location != NSNotFound);
    }
           
  });
}
@end