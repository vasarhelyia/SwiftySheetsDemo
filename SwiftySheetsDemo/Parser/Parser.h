//
//  Parser.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 08/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+ (void)startWithFileDescriptor:(int)fileDescriptor;
+ (void)scanString:(NSString *)string;

@end
