//
//  AST.h
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

#ifndef AST_h
#define AST_h

typedef const void * ASTRef;
typedef const char * ASTStr;

// utility
extern int row;
extern int column;

extern void AST_handle_error(const char *msg);
extern const char * AST_resolve_path(const char *path);
extern void AST_push_state(const char *path);
extern void AST_pop_state();

// literal
extern ASTRef AST_literal_create_fom_dec(ASTStr dec); // create a literal from str containing numeric value in decimal format
extern ASTRef AST_literal_create_fom_hex(ASTStr hex); // create a literal from str containing numeric value in hexa format
extern ASTRef AST_literal_create_fom_str(ASTStr str); // create a literal from str

// color
extern ASTRef AST_color_create_fom_rgb(ASTRef r, ASTRef g, ASTRef b); // returns a number composing color components
extern ASTRef AST_color_create_fom_rgba(ASTRef r, ASTRef g, ASTRef b, ASTRef a); // returns a number composing color components
extern ASTRef AST_color_create_fom_packed_rgb(ASTRef rgb);
extern ASTRef AST_color_create_fom_packed_rgba(ASTRef rgba);

// variable
extern ASTRef AST_variable_declare(ASTStr name, ASTRef value);
extern ASTRef AST_variable_get(ASTStr name);

// expression
extern ASTRef AST_expr_unary_minus(ASTRef expr);
extern ASTRef AST_expr_add(ASTRef op1, ASTRef op2);
extern ASTRef AST_expr_sub(ASTRef op1, ASTRef op2);
extern ASTRef AST_expr_mul(ASTRef op1, ASTRef op2);
extern ASTRef AST_expr_div(ASTRef op1, ASTRef op2);

// expression list
extern ASTRef AST_exprlist_create(ASTRef e1, ASTRef e2);
extern ASTRef AST_exprlist_append(ASTRef l, ASTRef e);

// tuple
extern ASTRef AST_tuple_create(ASTRef exprlist);

// property
extern ASTRef AST_property_create(ASTStr name, ASTRef value);

// styles
extern ASTRef AST_styledef_create(ASTStr name, ASTRef styleelements);
extern ASTRef AST_styledef_register(ASTRef styledef);
extern ASTRef AST_styleelements_create();
extern ASTRef AST_styleelements_append(ASTRef styleelements, ASTRef styleelement);


#endif /* AST_h */
