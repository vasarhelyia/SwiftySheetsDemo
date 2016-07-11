//
//  ASTTupleExpression.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTTupleExpression.h"

@interface ASTTupleExpression ()

@property(nonatomic, strong, readwrite) NSArray *elements;

@end

@implementation ASTTupleExpression

+ (instancetype)tupleWithElements:(NSArray *)elements {
	return [[self alloc] initWithElements:elements];
}

- (instancetype)initWithElements:(NSArray *)elements {
	self = [super init];
	if(self) {
		self.elements = elements;
	}
	return self;
}


- (ASTExprType)type {
	return ASTExprType_Tuple;
}

- (id)eval {
	NSMutableArray *value = NSMutableArray.array;
	for(ASTExpression *expr in self.elements) {
		id v = [expr eval];
		[value addObject:v];
	}
	return value;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Tup<%@>", self.elements];
}

@end
