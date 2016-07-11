//
//  ASTVariable.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTVariable.h"

@interface ASTVariable ()

@property(nonatomic, copy, readwrite) NSString *name;
@property(nonatomic, strong, readwrite) ASTExpression* value;

@end

@implementation ASTVariable

+ (instancetype)variableWithName:(NSString *)name value:(ASTExpression*)value {
	return [[self alloc] initWithName:name value:value];
}

- (instancetype)initWithName:(NSString *)name value:(ASTExpression*)value {
	self = [super init];
	if(self) {
		self.name = name;
		self.value = value;
	}
	return self;
}

- (ASTExprType)type {
	return self.value.type;
}

- (id)eval {
	return self.value.eval;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"var<%@: %@>", self.name, self.value.eval];
}

@end
