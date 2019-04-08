//
//  HLSafeMutableArray.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HLSafeMutableArray.h"
@interface HLSafeMutableArray(){
    CFMutableArrayRef _array;
}
@end
@implementation HLSafeMutableArray

- (id)init{
    
    return [self initWithCapacity:10];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        _array = CFArrayCreateMutable(kCFAllocatorDefault, numItems,  &kCFTypeArrayCallBacks);
    }
    return self;
}
- (NSUInteger)count {
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        result = CFArrayGetCount(_array);
    });
    return result;
}
- (id)objectAtIndex:(NSUInteger)index {
    
    __block id result;
    dispatch_sync(self.syncQueue, ^{
        NSUInteger count = CFArrayGetCount(_array);
        result = index<count ? CFArrayGetValueAtIndex(_array, index) : nil;
    });
    
    return result;
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    __block NSUInteger blockindex = index;
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
            return;
        
        NSUInteger count = CFArrayGetCount(_array);
        if (blockindex > count) {
            blockindex = count;
        }
        CFArrayInsertValueAtIndex(_array, index, (__bridge const void *)anObject);
        
    });
    
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = CFArrayGetCount(_array);
        NSLog(@"count:%lu,index:%lu",(unsigned long)count,(unsigned long)index);
        if (index < count) {
            CFArrayRemoveValueAtIndex(_array, index);
        }
    });
}


-(void)removeObject:(id)anObject{
    NSInteger index = [self indexOfObject:anObject];
    [self removeObjectAtIndex:index];
}
- (void)addObject:(id)anObject
{
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
            return;
        
        CFArrayAppendValue(_array, (__bridge const void *)anObject);
        
    });
}


- (void)removeLastObject {
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = CFArrayGetCount(_array);
        if (count > 0) {
            CFArrayRemoveValueAtIndex(_array, count-1);
        }
        
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
            return;
        
        NSUInteger count = CFArrayGetCount(_array);
        if (index<count) {
            CFArraySetValueAtIndex(_array, index, (__bridge const void*)anObject);
        }
    });
}

- (void)removeAllObjects
{
    
    dispatch_barrier_async(self.syncQueue, ^{
        CFArrayRemoveAllValues(_array);
    });
}
- (NSUInteger)indexOfObject:(id)anObject{
    
    if (!anObject)
        return NSNotFound;
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        NSUInteger count = CFArrayGetCount(_array);
        result = CFArrayGetFirstIndexOfValue(_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
    });
    return result;
}

#pragma mark ========== Private ==========
- (dispatch_queue_t)syncQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.kong.HLSafeMutableArray", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
    
}

@end
