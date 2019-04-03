//
//  NSObject+ZTUtil.h
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZTUtil)
/**
 *  获取所有类
 *
 *  @return <#return value description#>
 */
+ (NSArray *)allClasses;

/**
 *  获取指定类的所有子类
 *
 *  @param superClass <#superClass description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)allSubClassesOf:(Class)superClass;

/**
 *  获得类的所有属性
 *
 *  @param obj 类
 *
 *  @return 熟悉字典
 */
+ (NSArray *)getAllProperties:(id)obj;

/**
 *  获取Class的字符串
 *
 *  @return <#return value description#>
 */
+ (NSString *)classString;



/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)isNullOrNilWithObject:(id)object;
@end

NS_ASSUME_NONNULL_END
