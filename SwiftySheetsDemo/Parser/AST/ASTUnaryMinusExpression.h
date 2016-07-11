//
//  ASTUnaryMinusExpression.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTExpression.h"

@interface ASTUnaryMinusExpression : ASTExpression

@property(nonatomic, strong, readonly) ASTExpression *operand;

+ (instancetype)expressionWithOperand:(ASTExpression *)operand;

@end
