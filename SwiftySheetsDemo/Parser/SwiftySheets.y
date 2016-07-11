%{
	#import <stdio.h>
	#include "AST.h"
	
	extern void yyerror(const char *);
	extern int yylex(), yyparse(), yy_scan_string(const char *);
	
	#define YYERROR_VERBOSE 1
	#define YYDEBUG 1
%}


%token TK_IDENTIFIER
%token TK_VARIABLE
%token TK_STRING_LITERAL
%token TK_DECIMAL_LITERAL
%token TK_HEXA_LITERAL
%token TK_RGB
%token TK_RGBA

%left '+' '-'
%left '*' '/'
%left NEG

%start style_collection

%union {
	int		intval;
	ASTStr	strval;
	ASTRef	refval;
}

%%

style_collection
	: 
	| style_collection style_statement								{ AST_styledef_register($<strval>2); }
	;

style_statement
	: style_definition												{ $<refval>$ = $<refval>1; }
	| variable_definition											{ $<refval>$ = $<refval>1; }
	;

style_definition
	: TK_IDENTIFIER '{' style_definition_elements '}'				{ $<refval>$ = AST_styledef_create($<strval>1, $<refval>3); }
	;

style_definition_elements
	:																{ $<refval>$ = AST_styleelements_create(); }
	| style_definition_elements style_definition_element			{ $<refval>$ = AST_styleelements_append($<refval>1, $<refval>2); }
	;

style_definition_element
	: style_definition												{ $<refval>$ = $<refval>1; }
	| property_definition											{ $<refval>$ = $<refval>1; }
	;

property_definition
	: TK_IDENTIFIER ':' expr										{ $<refval>$ = AST_property_create($<strval>1, $<refval>3); }
	;

variable_definition
	: '$' TK_IDENTIFIER ':' expr									{ $<refval>$ = AST_variable_declare($<strval>2, $<strval>4); }

expr
	: TK_DECIMAL_LITERAL											{ $<refval>$ = AST_literal_create_fom_dec($<strval>1); }
	| TK_HEXA_LITERAL												{ $<refval>$ = AST_literal_create_fom_hex($<strval>1); }
	| TK_STRING_LITERAL												{ $<refval>$ = AST_literal_create_fom_str($<strval>1); }
	| variable														{ $<refval>$ = $<refval>1; }
	| tuple															{ $<refval>$ = $<refval>1; }
	| rgba															{ $<refval>$ = $<refval>1; }
	| rgb															{ $<refval>$ = $<refval>1; }
	| '(' expr ')'													{ $<refval>$ = $<refval>2; }
	| '-' expr	%prec NEG											{ $<refval>$ = AST_expr_unary_minus($<refval>2); }
	| expr '+' expr													{ $<refval>$ = AST_expr_add($<refval>1, $<refval>3); }
	| expr '-' expr													{ $<refval>$ = AST_expr_sub($<refval>1, $<refval>3); }
	| expr '*' expr													{ $<refval>$ = AST_expr_mul($<refval>1, $<refval>3); }
	| expr '/' expr													{ $<refval>$ = AST_expr_div($<refval>1, $<refval>3); }
;

variable
	: '$' TK_IDENTIFIER												{ $<refval>$ = AST_variable_get($<strval>2); }
;

tuple
	: '(' expr_list ')'												{ $<refval>$ = AST_tuple_create($<strval>2); }
	;

expr_list
	: expr ',' expr													{ $<refval>$ = AST_exprlist_create($<refval>1, $<refval>3); }
	| expr_list ',' expr											{ $<refval>$ = AST_exprlist_append($<refval>1, $<refval>3); }
	;

rgb
	: TK_RGB '(' expr ',' expr ',' expr ')'							{ $<refval>$ = AST_color_create_fom_rgb($<refval>3, $<refval>5, $<refval>7); }
	| TK_RGB '(' expr ')'											{ $<refval>$ = AST_color_create_fom_packed_rgb($<refval>3); }

rgba
	: TK_RGBA '(' expr ',' expr ',' expr ',' expr ')'				{ $<refval>$ = AST_color_create_fom_rgba($<refval>3, $<refval>5, $<refval>7, $<refval>9); }
	| TK_RGBA '(' expr ')'											{ $<refval>$ = AST_color_create_fom_packed_rgba($<refval>3); }

%%

#include <stdio.h>

void yyerror(const char *s)
{
	AST_handle_error(s);
}