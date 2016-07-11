//
//  ASTContext.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTContext.h"

@interface ASTContext()
@property(nonatomic, strong) NSMutableDictionary *variables;
@property(nonatomic, strong) NSMutableArray *styleDefinitions;
@end

@implementation ASTContext

- (instancetype)init {
	self = [super init];
	if(self) {
		self.variables = NSMutableDictionary.dictionary;
		self.styleDefinitions = NSMutableArray.array;
	}
	return self;
}

- (ASTVariable *)variableWithName:(NSString *)name {
	return self.variables[name];
}

- (void)addVariable:(ASTVariable *)variable {
	self.variables[variable.name] = variable;
}

- (ASTStyleDefinition *)definitionWithName:(NSString *)name {
	for(ASTStyleDefinition *definition in self.styleDefinitions) {
		if([definition.name isEqualToString:name]) return definition;
	}
	return nil;
}

- (void)addStyleDefinition:(ASTStyleDefinition *)styleDefinition {
	[self.styleDefinitions addObject:styleDefinition];
}

- (NSArray *)allStyleDefinitions {
	return self.styleDefinitions.copy;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"variables: %@\nstyles:%@", self.variables, self.styleDefinitions];
}

@end
