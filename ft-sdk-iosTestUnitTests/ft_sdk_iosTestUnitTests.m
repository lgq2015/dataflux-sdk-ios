//
//  ft_sdk_iosTestUnitTests.m
//  ft-sdk-iosTestUnitTests
//
//  Created by 胡蕾蕾 on 2019/12/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ZYUploadTool.h>
#import <FTMobileAgent/FTMobileAgent.h>
#import <ZYDataBase/ZYTrackerEventDBTool.h>
#import <ZYBaseInfoHander.h>
#import <RecordModel.h>
#import <FTAutoTrack/FTAutoTrack.h>

@interface ft_sdk_iosTestUnitTests : XCTestCase
@property (nonatomic, strong) FTAutoTrack *autoTrack;
@end


@implementation ft_sdk_iosTestUnitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
   FTMobileConfig *config = [FTMobileConfig new];
   config.enableRequestSigning = YES;
   config.akSecret = @"accsk";
   config.akId = @"accid";
   config.isDebug = YES;
   config.enableAutoTrack = YES;
   config.metricsUrl = @"http://10.100.64.106:19557/v1/write/metrics";
   self.autoTrack = [FTAutoTrack new];
   [self.autoTrack startWithConfig:config];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.autoTrack = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void)testWhiteListContainsViewController{
    
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testBtnClick{
    
}
@end