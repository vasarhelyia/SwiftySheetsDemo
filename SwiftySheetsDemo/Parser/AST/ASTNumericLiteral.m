//
//  ASTNumericLiteral.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTNumericLiteral.h"

@interface ASTNumericLiteral ()

@property(nonatomic, copy, readwrite) NSNumber *value;

@end

@implementation ASTNumericLiteral

+ (instancetype)literalWithFloat:(float)value {
	return [[self alloc] initWithFloat:value];
}

+ (instancetype)literalWithDecimalString:(NSString *)decimalString {
	return [[self alloc] initWithDecimalString:decimalString];
}

+ (instancetype)literalWithHexaString:(NSString *)hexaString {
	return [[self alloc] initWithHexaString:hexaString];
}

- (instancetype)initWithFloat:(float)value {
	self = [super init];
	if(self) {
		self.value = @(value);
	}
	return self;
}

- (instancetype)initWithDecimalString:(NSString *)decimalString {
	self = [super init];
	if(self) {
		self.value = [NSNumber numberWithFloat:decimalString.floatValue];
	}
	return self;
}

- (instancetype)initWithHexaString:(NSString *)hexaString {
	self = [super init];
	if(self) {
		unsigned result = 0;
		NSScanner *scanner = [NSScanner scannerWithString:hexaString];
		
		[scanner setScanLocation:1]; // bypass '#' character
		if([scanner scanHexInt:&result]) {
			self.value = @(result);
		} else {
			@throw [NSError errorWithDomain:@"ParserErrorDomain"
									   code:-2
								   userInfo:@{NSLocalizedDescriptionKey :  [NSString stringWithFormat:@"Failed to parse hexadecimal string: %@", hexaString]}];
		}
	}
	return self;	
}

- (ASTExprType)type {
	return ASTExprType_Numeric;
}

- (id)eval {
	return self.value;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Num<%@>", self.value];
}

@end
