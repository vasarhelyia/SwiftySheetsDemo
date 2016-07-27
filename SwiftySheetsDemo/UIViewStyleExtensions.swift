//
//  UIViewStyleExtensions.swift
//  SwiftySheetsDemo
//
//  Created by Agnes Vasarhelyi on 03/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation
import UIKit

@objc class Style: NSObject {
	var font: UIFont?
	var fontColor: UIColor?
	var fontColorAndState: (UIColor, UIControlState)?
	var textAlignment: NSTextAlignment?
}

extension UIView {
	@objc class func setStyle(style: Style, viewClass: AnyClass) { }
}

extension UILabel {
	override class func setStyle(style: Style, viewClass: AnyClass) {
		if let font = style.font {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).font = font
		}
		if let fontColor = style.fontColor {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).textColor = fontColor
		}
		if let textAlignment = style.textAlignment {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).textAlignment = textAlignment
		}
	}
}

extension UIButton {
	override class func setStyle(style: Style, viewClass: AnyClass) {
		if let font = style.font {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).titleLabel?.font = font
		}
		if let fontColor = style.fontColorAndState?.0,
			let state = style.fontColorAndState?.1 {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).setTitleColor(fontColor, forState: state)
		}
	}
}








