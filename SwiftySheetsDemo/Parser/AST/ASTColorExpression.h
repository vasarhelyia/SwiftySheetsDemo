//
//  ASTColorExpression.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTExpression.h"

@interface ASTColorExpression : ASTExpression

+ (instancetype)expressionWithRGB:(ASTExpression *)rgb;
+ (instancetype)expressionWithRGBA:(ASTExpression *)rgba;
+ (instancetype)expressionWithR:(ASTExpression *)r G:(ASTExpression *)g B:(ASTExpression *)b;
+ (instancetype)expressionWithR:(ASTExpression *)r G:(ASTExpression *)g B:(ASTExpression *)b A:(ASTExpression *)a;

@end
