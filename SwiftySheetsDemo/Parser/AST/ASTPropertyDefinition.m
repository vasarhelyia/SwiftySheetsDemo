//
//  ASTPropertyDefinition.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTPropertyDefinition.h"

@interface ASTPropertyDefinition()

@property(nonatomic, copy, readwrite) NSString *propertyName;
@property(nonatomic, strong, readwrite) ASTExpression * propertyValue;

@end

@implementation ASTPropertyDefinition

+ (instancetype)definitionWithPropertyName:(NSString *)propertyName propertyValue:(ASTExpression *)propertyValue {
	return [[self alloc] initWithPropertyName:propertyName propertyValue:propertyValue];
}

- (instancetype)initWithPropertyName:(NSString *)propertyName propertyValue:(ASTExpression *)propertyValue {
	self = [super init];
	if(self) {
		self.propertyName = propertyName;
		self.propertyValue = propertyValue;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ = %@", self.propertyName, self.propertyValue];
}

@end
