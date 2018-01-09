//
//  Calculator.m
//  CalculatorDemo
//
//  Created by Podul on 2018/1/9.
//  Copyright © 2018年 Podul. All rights reserved.
//

#import "Calculator.h"

typedef NS_ENUM(NSUInteger, CountType) {
    CountTypeAdding,                ///< 加
    CountTypeSubtracting,           ///< 减
    CountTypeMultiplying,           ///< 乘
    CountTypeDividing,              ///< 除
};

@interface Calculator()
@property (nonatomic, copy) NSString *strResult;///< 用来储存结果
@property (nonatomic, copy) NSString *strBegin; ///< 运算符前的输入的值
@property (nonatomic, copy) NSString *strEnd;///< 运算符后输入的值
@property (nonatomic, copy) NSString *symbol;///< 用来储存上一个运算符
@end

@implementation Calculator

- (instancetype)init {
    if (self = [super init]) {
        _strResult = @"0";
        _strBegin = @"0";
        _strEnd = @"0";
        _symbol = @"";
    }
    return self;
}

static id _instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

/// 计算
- (NSString *)caluculator:(NSString *)value {
    if ([self containsObjects:@[
                                @"+",
                                @"-",
                                @"x",
                                @"/",
                                @"="
                                ] hasObject:value]) {
        return [self isOperator:value];
    }else if ([self containsObjects:@[
                                      @"+/-",
                                      @"%",
                                      @"AC",
                                      @"."
                                      ] hasObject:value]) {
        return [self isOther:value];
    }else {
        return [self isNumber:value];
    }
}

#pragma mark - Privacy

/// 数字
- (NSString *)isNumber:(NSString *)value {
    NSString *tempStr = nil;
    if (_symbol.length == 0) {
        tempStr = _strBegin;
    }else {
        tempStr = _strEnd;
    }
    
    if ([value isEqualToString:@"0"] && ([tempStr isEqualToString:@"0"] || tempStr.length == 0)) {
        tempStr = @"0";
    }else {
        tempStr = [tempStr isEqualToString:@"0"] ? @"" : tempStr;
        tempStr = [tempStr stringByAppendingString:value];
    }
    
    _strResult = tempStr;
    if (_symbol.length == 0) {
        _strBegin = tempStr;
    }else {
        _strEnd = tempStr;
    }
    return _strResult;
}

/// 运算符(+, -, x, /, =)
- (NSString *)isOperator:(NSString *)value {
    NSString *tempStr = nil;
    if (_symbol.length == 0) {
        tempStr = _strBegin;
    }else {
        tempStr = _strEnd;
    }
    
    if (_symbol.length == 0) {
        // 储存运算符
        _symbol = [value isEqualToString:@"="] ? @"" : value;;
        _strBegin = tempStr;
        _strEnd = @"0";
        return _strResult;
    }else {
        // 先计算，再储存现在运算符
        NSDecimalNumber *result = nil;
        if ([_symbol isEqualToString:@"+"]) {
            result = [self countWithType:CountTypeAdding];
        }else if ([_symbol isEqualToString:@"-"]) {
            result = [self countWithType:CountTypeSubtracting];
        }else if ([_symbol isEqualToString:@"x"]) {
            result = [self countWithType:CountTypeMultiplying];
        }else if ([_symbol isEqualToString:@"/"]) {
            result = [self countWithType:CountTypeDividing];
        }
        
        _symbol = [value isEqualToString:@"="] ? @"" : value;
        _strBegin = [NSString stringWithFormat:@"%@",result];
        _strEnd = @"0";
        
        return [NSString stringWithFormat:@"%@",result];
    }
}

/// 其它
- (NSString *)isOther:(NSString *)value {
    NSString *tempStr = nil;
    if (_symbol.length == 0) {
        tempStr = _strBegin;
    }else {
        tempStr = _strEnd;
    }
    
    if ([value isEqualToString:@"AC"]) {
        // 清零
        _strResult = @"0";
        _strBegin = @"0";
        _strEnd = @"0";
        _symbol = @"";
        return _strResult;
    }else if ([value isEqualToString:@"+/-"]) {
        tempStr = [NSString stringWithFormat:@"%@",[self countWithType:CountTypeMultiplying beginValue:_strResult andEndValue:@"-1"]];
    }else if ([value isEqualToString:@"%"]) {
        tempStr = [NSString stringWithFormat:@"%@",[self countWithType:CountTypeDividing beginValue:_strResult andEndValue:@"100"]];
    }else if ([value isEqualToString:@"."]) {
        if (![tempStr containsString:@"."]) {
            tempStr = [tempStr stringByAppendingString:@"."];
        }
    }
    
    if (_symbol.length == 0) {
        _strBegin = tempStr;
    }else {
        _strEnd = tempStr;
    }
    
    _strResult = tempStr;
    return _strResult;
}

/// 判断数组中是否有某一对象
- (BOOL)containsObjects:(NSArray *)objects hasObject:(id)object {
    for (id obj in objects) {
        if ([obj isEqual:object]) {
            return YES;
        }
    }
    return NO;
}

- (NSDecimalNumber *)countWithType:(CountType)type {
    return [self countWithType:type beginValue:_strBegin andEndValue:_strEnd];
}

/// 四则运算
- (NSDecimalNumber *)countWithType:(CountType)type beginValue:(NSString *)beginValue andEndValue:(NSString *)endValue {
    NSDecimalNumber *beginNumber = [NSDecimalNumber decimalNumberWithString:beginValue];
    NSDecimalNumber *endNumber = [NSDecimalNumber decimalNumberWithString:endValue];
    NSDecimalNumber *reslutNumber = nil;
    switch (type) {
        case CountTypeAdding:{
            reslutNumber = [beginNumber decimalNumberByAdding:endNumber];
        }
            break;
        case CountTypeSubtracting:{
            reslutNumber = [beginNumber decimalNumberBySubtracting:endNumber];
        }
            break;
        case CountTypeMultiplying:{
            reslutNumber = [beginNumber decimalNumberByMultiplyingBy:endNumber];
        }
            break;
        case CountTypeDividing:{
            reslutNumber = [beginNumber decimalNumberByDividingBy:endNumber];
        }
            break;
    }
    
    return reslutNumber;
}

@end
