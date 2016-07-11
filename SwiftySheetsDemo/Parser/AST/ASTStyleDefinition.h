//
//  ASTStyleDefinition.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTPropertyDefinition.h"

@interface ASTStyleDefinition : NSObject

@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSMutableArray *children;
@property(nonatomic, strong, readonly) NSMutableArray *properties;

+ (instancetype)definitionWithName:(NSString *)name elements:(NSArray *)elements;

- (ASTStyleDefinition *)styleDefinitionWithName:(NSString *)name;
- (ASTPropertyDefinition *)propertyDefinitionWithName:(NSString *)name;

@end
