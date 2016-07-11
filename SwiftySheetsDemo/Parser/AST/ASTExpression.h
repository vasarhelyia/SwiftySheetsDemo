//
//  ASTExpression.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 10/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ASTExprType) {
	ASTExprType_Numeric,
	ASTExprType_String,
	ASTExprType_Tuple,
	ASTExprType_Color,
};

@interface ASTExpression : NSObject

@property(nonatomic, readonly) ASTExprType type;
- (id)eval;

@end
