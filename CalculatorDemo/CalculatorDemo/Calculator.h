//
//  Calculator.h
//  CalculatorDemo
//
//  Created by Podul on 2018/1/9.
//  Copyright © 2018年 Podul. All rights reserved.
//  计算类

#import <Foundation/Foundation.h>

@interface Calculator : NSObject
+ (instancetype)sharedInstance;

- (NSString *)caluculator:(NSString *)value;
@end
