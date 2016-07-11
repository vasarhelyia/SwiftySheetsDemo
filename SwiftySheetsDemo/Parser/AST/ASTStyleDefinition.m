//
//  ASTStyleDefinition.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTStyleDefinition.h"

@interface ASTStyleDefinition()

@property(nonatomic, copy, readwrite) NSString *name;
@property(nonatomic, strong, readwrite) NSMutableArray *children;
@property(nonatomic, strong, readwrite) NSMutableArray *properties;

@end

@implementation ASTStyleDefinition

+ (instancetype)definitionWithName:(NSString *)name elements:(NSArray *)elements {
	return [[self alloc] initWithName:name elements:elements];
}

- (instancetype)initWithName:(NSString *)name elements:(NSArray *)elements {
	self = [super init];
	if(self) {
		self.name = name;
		self.children = NSMutableArray.array;
		self.properties = NSMutableArray.array;
		for(id element in elements) {
			if([element isKindOfClass:ASTPropertyDefinition.class]) {
				[self addPropertyDefinition:(ASTPropertyDefinition *)element];
			} else if([element isKindOfClass:ASTStyleDefinition.class]) {
				[self addChildDefinition:(ASTStyleDefinition *)element];
			}
		}
	}
	return self;
}

- (void)addPropertyDefinition:(ASTPropertyDefinition *)propertyDefinition {
	[self.properties addObject:propertyDefinition];
}

- (void)addChildDefinition:(ASTStyleDefinition *)styleDefinition {
	[self.children addObject:styleDefinition];
}

- (ASTStyleDefinition *)styleDefinitionWithName:(NSString *)name {
	for(ASTStyleDefinition *def in self.children) {
		if([def.name isEqualToString:name]) return def;
	}
	return nil;
}

- (ASTPropertyDefinition *)propertyDefinitionWithName:(NSString *)name {
	for(ASTPropertyDefinition *def in self.properties) {
		if([def.propertyName isEqualToString:name]) return def;
	}
	return nil;
}


- (NSString *)description {
	return [NSString stringWithFormat:@"%@{\n%@ \n%@\n}" ,self.name, self.properties, self.children];
}

@end
