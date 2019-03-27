//
// Created by Brandon on 2019-03-23.
// Copyright (c) 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PW_DBNAME_INFORMATION @"information.sqlite"
#define PW_DBNAME_ISSUE @"issue.sqlite"
#define PW_DBNAME_MEMBER @"member.sqlite"
#define PW_DBNAME_LIBRARY @"library.sqlite"

#define PW_DB_ISSUE_ISSUE_BOARD_TABLE_NAME @"issue_board"
#define PW_DB_ISSUE_ISSUE_SOURCE_TABLE_NAME @"issue_source"
#define PW_DB_ISSUE_ISSUE_LOG_TABLE_NAME @"issue_log"
#define PW_DB_ISSUE_ISSUE_LIST_TABLE_NAME @"issue_list"

#define PW_DB_INFORMATION_TABLE_NAME @"information"
#define PW_DB_LIBRARY_TABLE_NAME @"library"

@interface BaseSqlHelper : NSObject

- (NSString *)getDBName;

- (PWFMDB *)getHelper;

- (void)onDBInit;

- (void)shutDown;
@end