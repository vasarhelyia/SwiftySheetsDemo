//
//  ASTNumericLiteral.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTExpression.h"

@interface ASTNumericLiteral : ASTExpression

@property(nonatomic, copy, readonly) NSNumber *value;

+ (instancetype)literalWithFloat:(float)value;
+ (instancetype)literalWithDecimalString:(NSString *)decimalString;
+ (instancetype)literalWithHexaString:(NSString *)hexaString;

@end
