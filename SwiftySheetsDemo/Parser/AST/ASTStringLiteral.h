//
//  ASTStringLiteral.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTExpression.h"

@interface ASTStringLiteral : ASTExpression

@property(nonatomic, copy, readonly) NSString *value;

+ (instancetype)literalWithString:(NSString *)string;

@end
