//
//  SwiftySheets.swift
//  SwiftySheetsDemo
//
//  Created by Agnes Vasarhelyi on 03/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import Foundation
import UIKit

struct LabelStyle {
	var font: UIFont?
	var fontColor: UIColor?
}

struct ButtonStyle {
	var fontColor: UIColor?
}

extension UILabel {
	class func setLabelStyle(style: LabelStyle, viewClass: AnyObject.Type) {
		if let font = style.font {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).font = font
		}
		if let fontColor = style.fontColor {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).textColor = fontColor
		}
	}
}

extension UIButton {
	class func setButtonStyle(style: ButtonStyle, viewClass: AnyObject.Type) {
		if let fontColor = style.fontColor {
			self.appearanceWhenContainedInInstancesOfClasses([viewClass]).tintColor = fontColor
		}
	}
}








