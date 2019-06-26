//
//  SelectObject.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectObject.h"

@implementation SelectObject
+ (BOOL)supportsSecureCoding {
    return YES; //支持加密编码
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:(NSInteger)_issueLevel forKey:@"issueLevel"];
    [aCoder encodeInteger:(NSInteger)_issueType forKey:@"issueType"];
    [aCoder encodeInteger:(NSInteger)_issueSortType forKey:@"issueSortType"];
    [aCoder encodeInteger:(NSInteger)_issueViewType forKey:@"issueViewType"];
    [aCoder encodeInteger:(NSInteger)_issueFrom forKey:@"issueFrom"];

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
    _issueLevel =(IssueLevel)[aDecoder decodeIntegerForKey:@"issueLevel"];
    _issueType = (IssueType)[aDecoder decodeIntegerForKey:@"issueType"];
    _issueSortType = (IssueSortType)[aDecoder decodeIntegerForKey:@"issueSortType"];
    _issueViewType = (IssueViewType)[aDecoder decodeIntegerForKey:@"issueViewType"];
    _issueFrom = (IssueFrom)[aDecoder decodeIntegerForKey:@"issueFrom"];
    }
    return self;
}
@end
