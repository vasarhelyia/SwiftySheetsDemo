//
//  ObjC.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 11/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "ObjC.h"

@implementation ObjC

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error {
	@try {
		tryBlock();
		return YES;
	}
	@catch (NSException *exception) {
		*error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
	}
	@catch (NSError *e) {
		*error = e;
	}
}

@end