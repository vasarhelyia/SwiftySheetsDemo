//
//  ASTColorExpression.swift
//  SwiftySheetsDemo
//
//  Created by Alföldi Norbert on 22/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation
import UIKit

@objc public class ASTColorExpression : NSObject, ASTExpression {
	public var r: ASTExpression
	public var g: ASTExpression
	public var b: ASTExpression
	public var a: ASTExpression
	
	init(r: ASTExpression, g: ASTExpression, b: ASTExpression, a: ASTExpression) {
		self.r = r
		self.g = g
		self.b = b
		self.a = a
	}
	
	convenience init(r: ASTExpression, g: ASTExpression, b: ASTExpression) {
		self.init(r: r, g: g, b: b, a: ASTNumericLiteral(floatLiteral: 255))
	}
	
	@objc(initWithRGBA:)
	convenience init(rgba: ASTExpression) {
		let r = ASTNumericLiteral(floatLiteral: Double(((rgba.eval() as! UInt) >> 24) & 0xff))
		let g = ASTNumericLiteral(floatLiteral: Double(((rgba.eval() as! UInt) >> 16) & 0xff))
		let b = ASTNumericLiteral(floatLiteral: Double(((rgba.eval() as! UInt) >>  8) & 0xff))
		let a = ASTNumericLiteral(floatLiteral: Double(((rgba.eval() as! UInt) >>  0) & 0xff))
		
		self.init(r: r, g: g, b: b, a: a)
	}
	
	@objc(initWithRGB:)
	convenience init(rgb: ASTExpression) {
		let r = ASTNumericLiteral(floatLiteral: Double(((rgb.eval() as! UInt) >> 16) & 0xff))
		let g = ASTNumericLiteral(floatLiteral: Double(((rgb.eval() as! UInt) >>  8) & 0xff))
		let b = ASTNumericLiteral(floatLiteral: Double(((rgb.eval() as! UInt) >>  0) & 0xff))
		let a = ASTNumericLiteral(floatLiteral: 255)

		self.init(r: r, g: g, b: b, a: a)
	}
	
	public func eval() -> AnyObject {
		let red = CGFloat(r.eval() as! Double) / 255
		let green = CGFloat(g.eval() as! Double) / 255
		let blue = CGFloat(b.eval() as! Double) / 255
		let alpha = CGFloat(a.eval() as! Double) / 255
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}
