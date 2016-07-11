//
//  ASTContext.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTVariable.h"
#import "ASTStyleDefinition.h"

@interface ASTContext : NSObject

- (ASTVariable *)variableWithName:(NSString *)name;
- (void)addVariable:(ASTVariable *)variable;

- (ASTStyleDefinition *)definitionWithName:(NSString *)name;
- (void)addStyleDefinition:(ASTStyleDefinition *)styleDefinition;
- (NSArray *)allStyleDefinitions;

@end
