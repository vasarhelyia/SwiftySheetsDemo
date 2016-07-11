//
//  Parser.m
//  SwiftySheetsDemo
//
//  Created by imihaly on 08/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#import "Parser.h"
#import "AST/AST.h"
#import "AST/ASTContext.h"
#import "AST/ASTNumericLiteral.h"
#import "AST/ASTStringLiteral.h"
#import "AST/ASTVariable.h"
#import "AST/ASTStyleDefinition.h"
#import "AST/ASTPropertyDefinition.h"
#import "AST/ASTUnaryMinusExpression.h"
#import "AST/ASTAddExpression.h"
#import "AST/ASTSubExpression.h"
#import "AST/ASTMulExpression.h"
#import "AST/ASTDivExpression.h"
#import "AST/ASTTupleExpression.h"
#import "AST/ASTColorExpression.h"

#import "SwiftySheets.tab.h"

extern void *yy_scan_string(const char *);

static ASTContext *context;
int row;
int column;
extern FILE *yyin;

extern void * yy_create_buffer( FILE *file, int size );
extern void yy_switch_to_buffer(void * buffer);

@interface Parser ()
@property(nonatomic, strong) NSMutableArray *fileStack;
@property(nonatomic, strong) NSMutableArray *stateStack;
@end

@implementation Parser

static Parser *instance = nil;

+ (Parser *)instance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = Parser.new;
	});
	return instance;
}

- (instancetype)init {
	self = [super init];
	if(self) {
		self.fileStack = NSMutableArray.array;
	}
	return self;
}

- (ASTContext *)parseFile:(NSString *)path {
	FILE *f = fopen(path.UTF8String, "r");
	if(f == NULL) {
		// TODO: throw error
		NSString *message = [NSString stringWithFormat:@"Could not open file at path: %@", path];
		@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey :  message}];
	}
	
	[self beginParsing];
	[self.fileStack addObject:path];
	yyin = f;

	yy_switch_to_buffer(yy_create_buffer( yyin, 16384 ) );
	
	if(0 != yyparse()) {
		fclose(f);
		return nil;
	}
	
	fclose(f);
	
	return context;
}

- (ASTContext *)parseString:(NSString *)string {
	[self beginParsing];
	yy_scan_string(string.UTF8String);
	
	if(0 != yyparse()) {
		return nil;
	}

	return context;
}

- (void)beginParsing {
	[self.fileStack removeAllObjects];
	context = ASTContext.new;
	row = 0;
	column = 0;
}

- (void)popFile {
	[self.fileStack removeLastObject];
}

- (void)pushState:(NSString *)path {
	[self.fileStack addObject:path];
	[self.stateStack addObject:@[@(row), @(column)]];
}

- (void)popState {
	[self popFile];
	NSArray *state = self.stateStack.lastObject;
	[self.stateStack removeLastObject];
	row = [state[0] intValue];
	column = [state[1] intValue];
}

- (NSString *)resolvePath:(NSString *)path {
	NSString *lastPath = self.fileStack.lastObject;
	NSString *dir = [lastPath stringByDeletingLastPathComponent];
	NSString *newFile = [dir stringByAppendingPathComponent:path];
	return newFile;
}

@end

#pragma mark - utility

void AST_handle_error(const char *msg) {
	NSString *message = nil;
	if(Parser.instance.fileStack.lastObject) {
		message = [[NSString stringWithUTF8String:msg] stringByAppendingFormat:@" at %@[%d:%d]", Parser.instance.fileStack.lastObject, row+1, column+1];
	} else {
		message = [[NSString stringWithUTF8String:msg] stringByAppendingFormat:@" at %d:%d", row+1, column+1];
	}

	@throw [NSError errorWithDomain:@"ParserErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey :  message}];
}

const char * AST_resolve_path(const char *path) {
	return [Parser.instance resolvePath:[NSString stringWithUTF8String:path]].UTF8String;
}

void AST_push_state(const char *path) {
	[Parser.instance pushState:[NSString stringWithUTF8String:path]];
}

void AST_pop_state() {
	[Parser.instance popState];
}


#pragma mark - literals

// create a literal from str containing numeric value in decimal format
ASTRef AST_literal_create_fom_dec(ASTStr dec) {
	NSString *str = [NSString stringWithUTF8String:dec];
	return CFBridgingRetain([ASTNumericLiteral literalWithDecimalString:str]);
}

// create a literal from str containing numeric value in hexa format
ASTRef AST_literal_create_fom_hex(ASTStr hex) {
	NSString *str = [NSString stringWithUTF8String:hex];
	return CFBridgingRetain([ASTNumericLiteral literalWithHexaString:str]);
}

// create a literal from str
ASTRef AST_literal_create_fom_str(ASTStr str) {
	NSString *string = [NSString stringWithUTF8String:str];
	return CFBridgingRetain([ASTStringLiteral literalWithString:string]);
}

#pragma mark - colors

ASTRef AST_color_create_fom_rgb(ASTRef r, ASTRef g, ASTRef b) {
	ASTExpression *r_expr = CFBridgingRelease(r);
	ASTExpression *g_expr = CFBridgingRelease(g);
	ASTExpression *b_expr = CFBridgingRelease(b);
	
	ASTColorExpression *expr = [ASTColorExpression expressionWithR:r_expr G:g_expr B:b_expr];
	return CFBridgingRetain(expr);
}

ASTRef AST_color_create_fom_rgba(ASTRef r, ASTRef g, ASTRef b, ASTRef a) {
	ASTExpression *r_expr = CFBridgingRelease(r);
	ASTExpression *g_expr = CFBridgingRelease(g);
	ASTExpression *b_expr = CFBridgingRelease(b);
	ASTExpression *a_expr = CFBridgingRelease(a);
	
	ASTColorExpression *expr = [ASTColorExpression expressionWithR:r_expr G:g_expr B:b_expr A:a_expr];
	return CFBridgingRetain(expr);
}

ASTRef AST_color_create_fom_packed_rgb(ASTRef rgb) {
	ASTExpression *rgb_expr = CFBridgingRelease(rgb);
	ASTColorExpression *expr = [ASTColorExpression expressionWithRGB:rgb_expr];
	return CFBridgingRetain(expr);
}

ASTRef AST_color_create_fom_packed_rgba(ASTRef rgba) {
	ASTExpression *rgba_expr = CFBridgingRelease(rgba);
	ASTColorExpression *expr = [ASTColorExpression expressionWithRGBA:rgba_expr];
	return CFBridgingRetain(expr);
}

#pragma mark - variables

// variable
ASTRef AST_variable_declare(ASTStr name, ASTRef value) {
	ASTVariable *var = [ASTVariable variableWithName:[NSString stringWithUTF8String:name] value:CFBridgingRelease(value)];
	return CFBridgingRetain(var);
}

ASTRef AST_variable_get(ASTStr name) {
	ASTVariable *var = [context variableWithName:[NSString stringWithUTF8String:name]];
	return CFBridgingRetain(var);
}

#pragma mark - expressions

ASTRef AST_expr_unary_minus(ASTRef expr) {
	ASTExpression *op = CFBridgingRelease(expr);
	ASTExpression *ret = [ASTUnaryMinusExpression expressionWithOperand:op];
	return CFBridgingRetain(ret);
}

ASTRef AST_expr_add(ASTRef op1, ASTRef op2) {
	ASTExpression *o1 = CFBridgingRelease(op1);
	ASTExpression *o2 = CFBridgingRelease(op2);
	ASTExpression *ret = [ASTAddExpression expressionWithOperand1:o1 operand2:o2];
	return CFBridgingRetain(ret);
}

ASTRef AST_expr_sub(ASTRef op1, ASTRef op2) {
	ASTExpression *o1 = CFBridgingRelease(op1);
	ASTExpression *o2 = CFBridgingRelease(op2);
	ASTExpression *ret = [ASTSubExpression expressionWithOperand1:o1 operand2:o2];
	return CFBridgingRetain(ret);
}

ASTRef AST_expr_mul(ASTRef op1, ASTRef op2) {
	ASTExpression *o1 = CFBridgingRelease(op1);
	ASTExpression *o2 = CFBridgingRelease(op2);
	ASTExpression *ret = [ASTMulExpression expressionWithOperand1:o1 operand2:o2];
	return CFBridgingRetain(ret);
}

ASTRef AST_expr_div(ASTRef op1, ASTRef op2) {
	ASTExpression *o1 = CFBridgingRelease(op1);
	ASTExpression *o2 = CFBridgingRelease(op2);
	ASTExpression *ret = [ASTDivExpression expressionWithOperand1:o1 operand2:o2];
	return CFBridgingRetain(ret);
}

#pragma mark - expression list

ASTRef AST_exprlist_create(ASTRef e1, ASTRef e2) {
	ASTExpression *exp1 = CFBridgingRelease(e1);
	ASTExpression *exp2 = CFBridgingRelease(e2);
	return CFBridgingRetain(@[exp1, exp2].mutableCopy);
}

ASTRef AST_exprlist_append(ASTRef l, ASTRef e) {
	NSMutableArray *elements = CFBridgingRelease(l);
	id element = CFBridgingRelease(e);

	[elements addObject:element];
	return CFBridgingRetain(elements);
}

#pragma mark - tuple

ASTRef AST_tuple_create(ASTRef exprlist) {
	NSMutableArray *elements = CFBridgingRelease(exprlist);
	ASTTupleExpression *tuple = [ASTTupleExpression tupleWithElements:elements];
	return CFBridgingRetain(tuple);
}


#pragma mark - properties

ASTRef AST_property_create(ASTStr name, ASTRef value) {
	id propertyValue = CFBridgingRelease(value);
	ASTPropertyDefinition *propertyDefinition = [ASTPropertyDefinition definitionWithPropertyName:[NSString stringWithUTF8String:name]
																					propertyValue:propertyValue];
	return CFBridgingRetain(propertyDefinition);
}


#pragma mark - styles

ASTRef AST_styledef_create(ASTStr name, ASTRef styleelements) {
	NSArray *elements = CFBridgingRelease(styleelements);
	ASTStyleDefinition *styleDefinition = [ASTStyleDefinition definitionWithName:[NSString stringWithUTF8String:name] elements:elements];
	return CFBridgingRetain(styleDefinition);
}

ASTRef AST_styledef_register(ASTRef style_element) {
	id element = CFBridgingRelease(style_element);
	if([element isKindOfClass:ASTStyleDefinition.class]) {
		[context addStyleDefinition:(ASTStyleDefinition *)element];
	} else if([element isKindOfClass:ASTVariable.class]) {
		[context addVariable:(ASTVariable *)element];
	}
	return NULL;
}

ASTRef AST_styleelements_create() {
	return CFBridgingRetain(NSMutableArray.array);
}

ASTRef AST_styleelements_append(ASTRef styleelements, ASTRef styleelement) {
	NSMutableArray *elements = CFBridgingRelease(styleelements);
	id element = CFBridgingRelease(styleelement);
	
	[elements addObject:element];
	return CFBridgingRetain(elements);
}
