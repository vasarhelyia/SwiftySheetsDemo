//
//  ASTColorExpression.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTColorExpression.h"
#import "ASTNumericLiteral.h"
#import <UIKit/UIKit.h>

@interface ASTColorExpression ()
@property(nonatomic, strong) ASTExpression *r;
@property(nonatomic, strong) ASTExpression *g;
@property(nonatomic, strong) ASTExpression *b;
@property(nonatomic, strong) ASTExpression *a;
@property(nonatomic, strong) ASTExpression *rgb;
@property(nonatomic, strong) ASTExpression *rgba;
@end

@implementation ASTColorExpression

+ (instancetype)expressionWithRGB:(ASTExpression *)rgb {
	return [[self alloc] initWithRGB:rgb];
}

+ (instancetype)expressionWithRGBA:(ASTExpression *)rgba {
	return [[self alloc] initWithRGBA:rgba];
}

+ (instancetype)expressionWithR:(ASTExpression *)r G:(ASTExpression *)g B:(ASTExpression *)b {
	return [self expressionWithR:r G:g B:b A:[ASTNumericLiteral literalWithFloat:255]];
}

+ (instancetype)expressionWithR:(ASTExpression *)r G:(ASTExpression *)g B:(ASTExpression *)b A:(ASTExpression *)a {
	return [[self alloc] initWithR:r G:g B:b A:a];
}

- (instancetype)initWithR:(ASTExpression *)r G:(ASTExpression *)g B:(ASTExpression *)b A:(ASTExpression *)a {
	if(r.type != ASTExprType_Numeric || g.type != ASTExprType_Numeric  || b.type != ASTExprType_Numeric  || a.type != ASTExprType_Numeric) {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}

	self = [super init];
	if(self) {
		self.r = r;
		self.g = g;
		self.b = b;
		self.a = a;
	}
	return self;
}

- (instancetype)initWithRGB:(ASTExpression *)rgb {
	if(rgb.type != ASTExprType_Numeric) {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}

	self = [super init];
	if(self) {
		self.rgb = rgb;
	}
	return self;
}

- (instancetype)initWithRGBA:(ASTExpression *)rgba {
	if(rgba.type != ASTExprType_Numeric) {
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey :  @"Invalid operand types"}];
	}
	self = [super init];
	if(self) {
		self.rgba = rgba;
	}
	return self;
}

- (ASTExprType)type {
	return ASTExprType_Color;
}

- (id)eval {
	float r = 0;
	float g = 0;
	float b = 0;
	float a = 0;
	
	if(self.rgba) {
		int val = [self.rgba.eval intValue];
		
		r = ((val >> 24) & 0xff) / 255.0;
		g = ((val >> 16) & 0xff) / 255.0;
		b = ((val >> 8) & 0xff) / 255.0;
		a = ((val >> 0) & 0xff) / 255.0;
		
	} else if(self.rgb) {

		int val = [self.rgb.eval intValue];
		
		r = ((val >> 16) & 0xff) / 255.0;
		g = ((val >> 8) & 0xff) / 255.0;
		b = ((val >> 0) & 0xff) / 255.0;
		a = 1.0;
		
	} else {
		r = [self.r.eval floatValue] / 255;
		g = [self.g.eval floatValue] / 255;
		b = [self.b.eval floatValue] / 255;
		a = [self.a.eval floatValue] / 255;
	}
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%@)", self.eval];
}

@end
