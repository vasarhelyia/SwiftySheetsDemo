//
//  Parser.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 08/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "Parser.h"

int row, column;

extern void *yy_scan_string(const char *);
extern FILE *yyin;
extern void * yy_create_buffer( FILE *file, int size );
extern void yy_switch_to_buffer(void * buffer);

@implementation Parser

+ (void)startWithFileDescriptor:(int)fileDescriptor {
	yyin = fdopen(fileDescriptor, "r");
	yy_switch_to_buffer(yy_create_buffer(yyin, 16384));
}

+ (void)scanString:(NSString *)string {
	yy_scan_string(string.UTF8String);
}

@end
