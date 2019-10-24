//
//  PWDocument.m
//  App
//
//  Created by 胡蕾蕾 on 2019/10/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWDocument.h"

@implementation PWDocument
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    DLog(@"typeName === %@",typeName);
    self.data = contents;
    return YES;
}
@end
