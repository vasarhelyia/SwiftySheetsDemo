//
//  ASTExpression.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

@objc public protocol ASTExpression {
	func eval() -> AnyObject
}
