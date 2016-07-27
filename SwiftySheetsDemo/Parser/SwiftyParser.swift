//
//  SwiftyParser.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 16/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

private struct State {
	let row: Int
	let column: Int
}

@objc public class SwiftyParser : NSObject {
	public static let sharedInstance = SwiftyParser()
	private static var context: ASTContext?
	
	private var fileStack = Array<String>()
	private var stateStack = Array<State>()
	
	public func parseFile(path: String) throws -> ASTContext {
		guard let fileHandle = NSFileHandle(forReadingAtPath: path) else {
			throw NSError(domain: "ParserErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not open file at path: \(path)"])
		}
		
		defer {
			fileHandle.closeFile()
		}
		
		beginParsing()
		
		fileStack.append(path)
		Parser.startWithFileDescriptor(fileHandle.fileDescriptor)
		
		guard yyparse() == 0 else {
			throw NSError(domain: "ParserErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse file at path: \(path)"])
		}
		
		return SwiftyParser.context!
	}
	
	public func parseString(string: String) throws -> ASTContext {
		beginParsing()
		Parser.scanString(string)
		
		guard yyparse() == 0 else {
			throw NSError(domain: "ParserErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse string"])
		}
		
		return SwiftyParser.context!
	}
	
	private func beginParsing() {
		fileStack.removeAll()
		SwiftyParser.context = ASTContext()
	}
	
	private func popFile() {
		if fileStack.count > 0 {
			fileStack.removeLast()
		}
	}
	
	private func pushState(path: String) {
		fileStack.append(path)
		stateStack.append(State(row: Int(row), column: Int(column)))
	}
	
	private func popState() {
		popFile()
		
		if let state = stateStack.last {
			row = CInt(state.row)
			column = CInt(state.column)
			
			stateStack.removeLast()
		}
	}
	
	private func resolvePath(path: String) -> String? {
		guard let lastPath = fileStack.last else { return nil }
		
		let lastDirectory = (lastPath as NSString).stringByDeletingLastPathComponent
		let resolvedPath = (lastDirectory as NSString).stringByAppendingPathComponent(path)
		
		return resolvedPath
	}
	
	public static func AST_handle_error(msg: String) {
		if let path = SwiftyParser.sharedInstance.fileStack.last {
			print("\(path):\(row):\(column): error: \(msg)")
		} else {
			print("Error: \(msg)")
		}
	}
	
	public static func AST_resolve_path(path: String) -> UnsafePointer<Int8> {
		guard let resolvedPath = SwiftyParser.sharedInstance.resolvePath(path) else { return nil }
		return (resolvedPath as NSString).UTF8String
	}
	
	public static func AST_push_state(path: String) {
		SwiftyParser.sharedInstance.pushState(path)
	}
	
	public static func AST_pop_state() {
		SwiftyParser.sharedInstance.popState()
	}
	
	public static func AST_styledef_register(styleElement: ASTExpression) {
		if let styleDefinition = styleElement as? ASTStyleDefinition {
			SwiftyParser.context?.addStyleDefinition(styleDefinition)
		} else if let styleVariable = styleElement as? ASTVariable {
			SwiftyParser.context?.addVariable(styleVariable)
		}
	}
	
	public static func AST_variable_get(name: String) -> ASTVariable? {
		return context?.variableWithName(name)
	}
	
	public static func AST_styledef_create(name: String, elements: Array<ASTStyleDefinition>) -> ASTStyleDefinition {
		return ASTStyleDefinition(name: name, elements: elements)
	}
	
	public static func AST_styleelements_create() -> Array<ASTStyleDefinition> {
		return Array<ASTStyleDefinition>()
	}
	
	public static func AST_styleelements_append(var elements: Array<ASTStyleDefinition>, element: ASTStyleDefinition) -> Array<ASTStyleDefinition> {
		elements.append(element)
		return elements
	}
	
	public static func AST_literal_create_fom_dec(dec: String) -> ASTNumericLiteral {
		return ASTNumericLiteral(stringLiteral: dec)
	}
	
	public static func AST_literal_create_fom_hex(hex: String) -> ASTNumericLiteral {
		return ASTNumericLiteral(stringLiteral: hex)
	}
	
	public static func AST_literal_create_fom_str(str: String) -> ASTStringLiteral {
		return ASTStringLiteral(stringLiteral: str)
	}
	
	public static func AST_exprlist_create(left: ASTExpression, right: ASTExpression) -> Array<ASTExpression> {
		var list = Array<ASTExpression>()
		list.append(left)
		list.append(right)
		
		return list
	}
	
	public static func AST_exprlist_append(var list: Array<ASTExpression>, element: ASTExpression) -> Array<ASTExpression> {
		list.append(element)
		
		return list
	}
	
	public static func AST_variable_declare(name: String, value: ASTExpression) -> ASTVariable {
		return ASTVariable(name: name, value: value)
	}
	
	public static func AST_property_create(name: String, value: ASTExpression) -> ASTPropertyDefinition {
		return ASTPropertyDefinition(propertyName: name, propertyValue: value)
	}
	
	public static func AST_expr_minus(operand: ASTExpression) -> ASTExpression? {
		if let numericLiteral = operand as? ASTNumericLiteral {
			return -numericLiteral
		}
		
		return ASTUnaryOperation(operand: operand)
	}
	
	@objc(AST_expr_add_left:right:)
	public static func AST_expr_add(left: ASTExpression, right: ASTExpression) -> ASTExpression {
		if let left = left as? ASTNumericLiteral, let right = right as? ASTNumericLiteral {
			return left + right
		}
		else if let left = left as? ASTStringLiteral, let right = right as? ASTStringLiteral {
			return left + right
		}
		
		return ASTBinaryOperation(leftOperand: left, rightOperand: right, operation: .Add)
	}
	
	@objc(AST_expr_sub_left:right:)
	public static func AST_expr_sub(left: ASTExpression, right: ASTExpression) -> ASTExpression {
		return ASTBinaryOperation(leftOperand: left, rightOperand: right, operation: .Sub)
	}
	
	@objc(AST_expr_mul_left:right:)
	public static func AST_expr_mul(left: ASTExpression, right: ASTExpression) -> ASTExpression {
		if let left = left as? ASTNumericLiteral, let right = right as? ASTNumericLiteral {
			return left * right
		}
		
		return ASTBinaryOperation(leftOperand: left, rightOperand: right, operation: .Mul)
	}
	
	@objc(AST_expr_div_left:right:)
	public static func AST_expr_div(left: ASTExpression, right: ASTExpression) -> ASTExpression {
		return ASTBinaryOperation(leftOperand: left, rightOperand: right, operation: .Div)
	}
	
	@objc(AST_color_create_from_r:g:b:)
	public static func AST_color_create_from_rgb(r: ASTExpression, g: ASTExpression, b: ASTExpression) -> ASTColorExpression {
		return ASTColorExpression(r: r, g: g, b: b)
	}
	
	public static func AST_color_create_from_packed_rgb(rgb: ASTExpression) -> ASTColorExpression {
		return ASTColorExpression(rgb: rgb)
	}
	
	@objc(AST_color_create_from_r:g:b:a:)
	public static func AST_color_create_from_rgba(r: ASTExpression, g: ASTExpression, b: ASTExpression, a: ASTExpression) -> ASTColorExpression {
		return ASTColorExpression(r: r, g: g, b: b, a: a)
	}
	
	public static func AST_color_create_from_packed_rgba(rgba: ASTExpression) -> ASTColorExpression {
		return ASTColorExpression(rgba: rgba)
	}
}
