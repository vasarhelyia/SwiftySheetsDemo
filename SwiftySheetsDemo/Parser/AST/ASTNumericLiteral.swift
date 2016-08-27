//
//  ASTNumericLiteral.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

@objc public class ASTNumericLiteral : NSObject, ASTExpression, FloatLiteralConvertible, StringLiteralConvertible {
	public var value: Double
	
	public required init(floatLiteral value: FloatLiteralType) {
		self.value = value
	}
	
	public required init(stringLiteral value: StringLiteralType) {
		self.value = ASTNumericLiteral.convert(value) ?? 0
	}
	
	public typealias UnicodeScalarLiteralType = StringLiteralType
	public required init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.value = ASTNumericLiteral.convert(value) ?? 0
	}
	
	public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	public required init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.value = ASTNumericLiteral.convert(value) ?? 0
	}
	
	private static func convert(value: String) -> Double? {
		if value.hasPrefix("#") {
			var intValue: CUnsignedInt = 0
			let scanner = NSScanner(string: value.substringFromIndex(value.startIndex.advancedBy(1)))
			scanner.scanHexInt(&intValue)
			
			return Double(intValue)
		} else {
			return Double(value)
		}
	}
	
	public func eval() -> AnyObject {
		return self.value
	}
}
