//
//  NSObject+ZTUtil.m
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NSObject+ZTUtil.h"
#import <objc/runtime.h>


@implementation NSObject (ZTUtil)
+ (NSArray *)allClasses
{
    static NSMutableArray * __allClasses = nil;
    
    if ( nil == __allClasses )
    {
        __allClasses = [NSMutableArray array];
    }
    
    if ( 0 == __allClasses.count )
    {
        
        unsigned int    classesCount = 0;
        Class *            classes = objc_copyClassList( &classesCount );
        
        for ( unsigned int i = 0; i < classesCount; ++i )
        {
            Class classType = classes[i];
            Class superClass = class_getSuperclass( classType );
            
            if ( nil == superClass )
                continue;
            if ( NO == class_respondsToSelector( classType, @selector(doesNotRecognizeSelector:) ) )
                continue;
            if ( NO == class_respondsToSelector( classType, @selector(methodSignatureForSelector:) ) )
                continue;
            
            [__allClasses addObject:classType];
        }
        
        free( classes );
    }
    
    return __allClasses;
}

+ (NSArray *)allSubClassesOf:(Class)superClass
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( Class classType in [self allClasses] )
    {
        if ( classType == superClass )
            continue;
        
        if ( NO == [classType isSubclassOfClass:superClass] )
            continue;
        
        [results addObject:classType];
    }
    
    return results;
}

+ (NSArray *)getAllProperties:(id)obj
{
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([obj class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

+ (NSString *)classString {
    NSString *classString = NSStringFromClass([self class]);
    NSArray *array = [classString componentsSeparatedByString:@"."];
    if (array.count == 2) {
        return array.lastObject;
    }
    
    return classString;
}


+ (BOOL)isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""] || [object length] == 0) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}
@end
