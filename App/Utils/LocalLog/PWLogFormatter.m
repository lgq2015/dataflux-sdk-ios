//
//  PWLogFormatter.m
//  yunku3
//
//  Created by wqc on 2016/12/22.
//  Copyright © 2016年 wqc. All rights reserved.
//

#import "PWLogFormatter.h"

@interface PWLogFormatter ()

@property(nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation PWLogFormatter

-(instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss:SSS";
    }
    return self;
}

-(NSString*)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = @"";
    switch (logMessage.level) {
        case DDLogLevelDebug:
            logLevel = @"Debug";
            break;
        case DDLogLevelInfo:
            logLevel = @"Info";
            break;
        case DDLogLevelWarning:
            logLevel = @"Warn";
            break;
        case DDLogLevelVerbose:
            logLevel = @"Verbose";
            break;
        default:
            break;
    }
    
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ T:%@ - %@",[_dateFormatter stringFromDate:[NSDate date]],logLevel,logMessage.threadID, logMessage->_message];
    
    return formatStr;
}

@end
