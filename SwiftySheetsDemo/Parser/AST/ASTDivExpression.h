//
//  ASTDivExpression.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTExpression.h"

@interface ASTDivExpression : ASTExpression

@property(nonatomic, strong, readonly) ASTExpression *operand1;
@property(nonatomic, strong, readonly) ASTExpression *operand2;

+ (instancetype)expressionWithOperand1:(ASTExpression *)operand1 operand2:(ASTExpression *)operand2;

@end
