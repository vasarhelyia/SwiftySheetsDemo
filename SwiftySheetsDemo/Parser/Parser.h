//
//  Parser.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 08/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AST/ASTContext.h"

@interface Parser : NSObject

+ (Parser *)instance;

- (ASTContext *)parseFile:(NSString *)path;
- (ASTContext *)parseString:(NSString *)string;

@end
