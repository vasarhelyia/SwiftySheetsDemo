//
//  ASTOperations.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 24/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

public enum ASTUnaryOperationType: Int {
	case Minus
}

public enum ASTBinaryOperationType: Int {
	case Add
	case Sub
	case Mul
	case Div
}

public class ASTUnaryOperation : NSObject, ASTExpression {
	let operand: ASTExpression
	let operationType: ASTUnaryOperationType
	
	init(operand: ASTExpression, operation: ASTUnaryOperationType = .Minus) {
		self.operand = operand
		self.operationType = operation
	}
	
	public func eval() -> AnyObject {
		switch self.operationType {
		case .Minus:
			return -(self.operand.eval() as! Double)
		}
	}
}

public class ASTBinaryOperation : NSObject, ASTExpression {
	let leftOperand: ASTExpression
	let rightOperand: ASTExpression
	let operationType: ASTBinaryOperationType
	
	init(leftOperand: ASTExpression, rightOperand: ASTExpression, operation: ASTBinaryOperationType) {
		self.leftOperand = leftOperand
		self.rightOperand = rightOperand
		self.operationType = operation
	}
	
	public func eval() -> AnyObject {
		let leftOperand = self.leftOperand.eval() as! Double
		let rightOperand = self.rightOperand.eval() as! Double
		
		switch self.operationType {
		case .Add:
			return leftOperand + rightOperand
		case .Sub:
			return leftOperand - rightOperand
		case .Mul:
			return leftOperand * rightOperand
		case .Div:
			return leftOperand / rightOperand
		}
	}
}

prefix func -(operand: ASTNumericLiteral) -> ASTNumericLiteral {
	return ASTNumericLiteral(floatLiteral: -operand.value)
}

func +(left: ASTNumericLiteral, right: ASTNumericLiteral) -> ASTNumericLiteral {
	return ASTNumericLiteral(floatLiteral: left.value + right.value)
}

func -(left: ASTNumericLiteral, right: ASTNumericLiteral) -> ASTNumericLiteral {
	return ASTNumericLiteral(floatLiteral: left.value - right.value)
}

func *(left: ASTNumericLiteral, right: ASTNumericLiteral) -> ASTNumericLiteral {
	return ASTNumericLiteral(floatLiteral: left.value * right.value)
}

func /(left: ASTNumericLiteral, right: ASTNumericLiteral) -> ASTNumericLiteral {
	return ASTNumericLiteral(floatLiteral: left.value / right.value)
}

func +(left: ASTStringLiteral, right: ASTStringLiteral) -> ASTStringLiteral {
	return ASTStringLiteral(stringLiteral: left.value + right.value)
}
