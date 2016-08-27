//
//  ASTStyleDefinition.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 19/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation

public class ASTStyleDefinition : NSObject {
	public var name: String
	public var children = Array<ASTStyleDefinition>()
	public var properties = Array<ASTPropertyDefinition>()
	
	public init(name: String, elements: Array<AnyObject>) {
		self.name = name
		
		for element in elements where element is ASTStyleDefinition {
			self.children.append(element as! ASTStyleDefinition)
		}
		
		for element in elements where element is ASTPropertyDefinition {
			self.properties.append(element as! ASTPropertyDefinition)
		}
	}
	
	public func addStyleDefinition(styleDefinition: ASTStyleDefinition) {
		self.children.append(styleDefinition)
	}
	
	public func addPropertyDefinition(propertyDefinition: ASTPropertyDefinition) {
		self.properties.append(propertyDefinition)
	}
	
	public func styleDefinitionWithName(name: String) -> ASTStyleDefinition? {
		return self.children.filter({ $0.name == name }).first
	}
	
	public func propertyDefinitionWithName(name: String) -> ASTPropertyDefinition? {
		return self.properties.filter({ $0.propertyName == name }).first
	}
}
