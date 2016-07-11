//
//  ASTUnaryMinusExpression.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTUnaryMinusExpression.h"

@interface ASTUnaryMinusExpression ()

@property(nonatomic, strong, readwrite) ASTExpression *operand;

@end

@implementation ASTUnaryMinusExpression

+ (instancetype)expressionWithOperand:(ASTExpression *)operand {
	return [[self alloc] initWithOperand:operand];
}

- (instancetype)initWithOperand:(ASTExpression *)operand {
	self = [super init];
	if(self) {
		self.operand = operand;
	}
	return self;
}

- (ASTExprType)type {
	if(self.operand.type == ASTExprType_Numeric) {
		return ASTExprType_Numeric;
	} else {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}
}

- (id)eval {
	if(self.operand.type == ASTExprType_Numeric) {
		return @(-[[self.operand eval] floatValue]);
	} else {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"-(%@)", self.operand];
}


@end
