//
//  ASTDivExpression.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTDivExpression.h"

@interface ASTDivExpression ()

@property(nonatomic, strong, readwrite) ASTExpression *operand1;
@property(nonatomic, strong, readwrite) ASTExpression *operand2;

@end

@implementation ASTDivExpression

+ (instancetype)expressionWithOperand1:(ASTExpression *)operand1 operand2:(ASTExpression *)operand2 {
	return [[self alloc] initWithOperand1:operand1 operand2:operand2];
}

- (instancetype)initWithOperand1:(ASTExpression *)operand1 operand2:(ASTExpression *)operand2 {
	self = [super init];
	if(self) {
		self.operand1 = operand1;
		self.operand2 = operand2;
	}
	return self;
}

- (ASTExprType)type {
	if(self.operand1.type == ASTExprType_Numeric && self.operand2.type == ASTExprType_Numeric) {
		return ASTExprType_Numeric;
	} else {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}
}

- (id)eval {
	if(self.operand1.type == ASTExprType_Numeric && self.operand2.type == ASTExprType_Numeric) {
		if([self.operand2.eval floatValue] * MAXFLOAT < [self.operand1.eval floatValue]) {
			@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-4 userInfo:@{NSLocalizedDescriptionKey :  @"overflow"}];
		}
		return @([self.operand1.eval floatValue] / [self.operand2.eval floatValue]);
	} else {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%@ / %@)", self.operand1, self.operand2];
}

@end
