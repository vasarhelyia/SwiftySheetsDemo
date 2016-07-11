//
//  ObjC.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 11/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end