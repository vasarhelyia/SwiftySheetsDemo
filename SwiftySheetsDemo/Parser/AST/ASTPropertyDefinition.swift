//
//  ASTPropertyDefinition.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

public class ASTPropertyDefinition : NSObject {
	public var propertyName: String
	public var propertyValue: ASTExpression
	
	init(propertyName: String, propertyValue: ASTExpression) {
		self.propertyName = propertyName
		self.propertyValue = propertyValue
	}
}
