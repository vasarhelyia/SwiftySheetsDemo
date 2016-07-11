//
//  ASTVariable.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTExpression.h"

@interface ASTVariable : ASTExpression

@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, strong, readonly) ASTExpression* value;

+ (instancetype)variableWithName:(NSString *)name value:(ASTExpression *)value;

@end
