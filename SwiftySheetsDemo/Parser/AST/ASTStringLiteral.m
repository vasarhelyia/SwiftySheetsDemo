//
//  ASTStringLiteral.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTStringLiteral.h"

@interface ASTStringLiteral()
@property(nonatomic, copy, readwrite) NSString *value;
@end

@implementation ASTStringLiteral

+ (instancetype)literalWithString:(NSString *)string {
	return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string {
	self = [super init];
	if(self) {
		self.value = string;
	}
	return self;
}

- (ASTExprType)type {
	return ASTExprType_String;
}

- (id)eval {
	return self.value;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Str<%@>", self.value];
}

@end
