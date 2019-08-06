//
//  PWDiskCache.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/9.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWDiskCache.h"

@implementation PWDiskCache
+ (void)writeData:(id)data
            toDir:(NSString *)directory
         filename:(NSString *)filename{
    assert(data);
    
    assert(directory);
    
    assert(filename);
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (error) {
        NSLog(@"createDirectory error is %@",error.localizedDescription);
        return;
    }
    
    NSString *filePath = [directory stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
}

+ (id)readDataFromDir:(NSString *)directory
             filename:(NSString *)filename {
    assert(directory);
    
    assert(filename);
    
    NSData *data = nil;
    
    NSString *filePath = [directory stringByAppendingPathComponent:filename];
    
    data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    return data;
}

+ (NSUInteger)dataSizeInDir:(NSString *)directory {
    
    if (!directory) {
        return 0;
    }
    
    BOOL isDir = NO;
    NSUInteger total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
            if (!error) {
                for (NSString *subFile in array) {
                    NSString *filePath = [directory stringByAppendingPathComponent:subFile];
                    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
                    
                    if (!error) {
                        total += [attributes[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (void)clearDataIinDir:(NSString *)directory {
    if (directory) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:directory error:&error];
            if (error) {
                NSLog(@"delectError：%@",error.localizedDescription);
            }
        }
    }
}

+ (void)deleteCache:(NSString *)fileUrl {
    if (fileUrl) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileUrl]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:&error];
            if (error) {
                NSLog(@"delectError：%@",error.localizedDescription);
            }
        }else {
            NSLog(@"NO File");
        }
    }
}

@end
