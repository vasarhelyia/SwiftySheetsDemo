//
//  ASTVariable.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

@objc public class ASTVariable : NSObject, ASTExpression {
	public var name: String
	public var value: ASTExpression
	
	public init(name: String, value: ASTExpression) {
		self.name = name
		self.value = value
	}
	
	public func eval() -> AnyObject {
		return self.value.eval()
	}
}
