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
		guard let font = style.font,
			let fontColor = style.fontColor else {
				return
		}
		
		self.appearanceWhenContainedInInstancesOfClasses([viewClass]).font = font
		self.appearanceWhenContainedInInstancesOfClasses([viewClass]).textColor = fontColor
	}
}

extension UIButton {
	class func setButtonStyle(style: ButtonStyle, viewClass: AnyObject.Type) {
		guard let fontColor = style.fontColor else {
				return
		}
		
		self.appearanceWhenContainedInInstancesOfClasses([viewClass]).tintColor = fontColor
	}
}
