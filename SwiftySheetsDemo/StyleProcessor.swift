//
//  StyleProcessor.swift
//  SwiftySheetsDemo
//
//  Created by Agnes Vasarhelyi on 25/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import UIKit

class StyleProcessor {
	
	class func processContext(context: ASTContext) {
		
		for styleDef in context.allStyleDefinitions() {
			let parentDef = styleDef as! ASTStyleDefinition
			for childDef in styleDef.children {
				let style = childDef as! ASTStyleDefinition
				for property in style.properties {
					let prop = property as! ASTPropertyDefinition
					let name = prop.propertyName
					let value = prop.propertyValue
					let viewClass = NSClassFromString(style.name) as! UIView.Type

					guard let containerClass = NSClassFromString("SwiftySheetsDemo.\(parentDef.name)") else {
						continue
					}
					
					let s = Style()
					switch name {
					case fontName:
						if let font = value.eval() as? String {
							if let size = style.propertyDefinitionWithName(fontSize).propertyValue.eval() as? CGFloat {
								s.font = UIFont(name: font, size: size)
							}
						}
					case fontSize:
						break
					case fontColor:
						if let fontColor = value.eval() as? UIColor {
							s.fontColor = fontColor
						}
					case fontColorNormal:
						if let fontColor = value.eval() as? UIColor {
							s.fontColorAndState = (fontColor, .Normal)
						}
					default:
						break
					}

					viewClass.setStyle(s, viewClass:containerClass)
				}
			}
		}
	}

}