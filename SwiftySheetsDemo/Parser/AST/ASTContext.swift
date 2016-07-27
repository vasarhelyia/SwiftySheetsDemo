//
//  ASTContext.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

public class ASTContext : NSObject {
	private var variables = Dictionary<String, ASTVariable>()
	private var styleDefinitions = Array<ASTStyleDefinition>()
	
	public func variableWithName(name: String) -> ASTVariable? {
		return self.variables[name]
	}
	
	public func addVariable(variable: ASTVariable) {
		self.variables[variable.name] = variable
	}
	
	public func definitionWithName(name: String) -> ASTStyleDefinition? {
		return self.styleDefinitions.filter({ $0.name == name }).first
	}
	
	public func addStyleDefinition(styleDefinition: ASTStyleDefinition) {
		self.styleDefinitions.append(styleDefinition)
	}
	
	public func allStyleDefinitions() -> Array<ASTStyleDefinition> {
		return self.styleDefinitions
	}
}
