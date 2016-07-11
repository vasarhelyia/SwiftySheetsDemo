//
//  ASTPropertyDefinition.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTExpression.h"

@interface ASTPropertyDefinition : NSObject

@property(nonatomic, copy, readonly) NSString *propertyName;
@property(nonatomic, strong, readonly) ASTExpression *propertyValue;

+ (instancetype)definitionWithPropertyName:(NSString *)propertyName propertyValue:(ASTExpression *)propertyValue;

@end
