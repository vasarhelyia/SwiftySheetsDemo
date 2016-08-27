//
//  ASTStringLiteral.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

@objc public class ASTStringLiteral : NSObject, ASTExpression, StringLiteralConvertible {
	public var value: String
	
	public required init(stringLiteral value: StringLiteralType) {
		self.value = value
	}
	
	public typealias UnicodeScalarLiteralType = StringLiteralType
	public required init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.value = value
	}
	
	public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	public required init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.value = value
	}
	
	public func eval() -> AnyObject {
		return self.value
	}
}
