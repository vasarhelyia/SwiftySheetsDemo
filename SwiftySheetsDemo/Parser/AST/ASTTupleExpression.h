//
//  ASTTupleExpression.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ASTExpression.h"

@interface ASTTupleExpression : ASTExpression

@property(nonatomic, strong, readonly) NSArray *elements;

+ (instancetype)tupleWithElements:(NSArray *)elements;

@end
