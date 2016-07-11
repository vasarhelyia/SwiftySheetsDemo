//
//  ParserTests.swift
//  SwiftySheetsDemo
//
//  Created by imihaly on 09/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseEmptyFile() {
		// WHEN
		let parser = Parser.instance()
		let context = parser.parseString("")
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 0)
    }
	
	func testParsingSingleLineComment() {
		// WHEN
		let stylesheet = "// Style {}"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 0)
	}

	func testParsingMultiLineComment() {
		// WHEN
		let stylesheet = "/* Style1 {} \n Style2 {} \n */"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 0)
	}

	func testParseTrivialStyle() {
		// WHEN
		let stylesheet = "Style {}"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 1)
		let styleDefinition = context.allStyleDefinitions()[0] as! ASTStyleDefinition
		XCTAssertEqual(styleDefinition.name, "Style")
	}

	func testParseVariableDeclaration() {
		// WHEN
		let stylesheet = "$variable : 1"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.variableWithName("variable") != nil)
	}

	func testParsePropertySetting() {
		// WHEN
		let stylesheet = "Style { \n" +
							"property1 : 1 \n" +
							"property2 : -1 \n" +
							"property3 : 1.1 \n" +
							"property4 : -1.1 \n" +
							"property5 : 1. \n" +
							"property6 : -1. \n" +
							"property7 : .1 \n" +
							"property8 : -.1 \n" +
							"property9 : \" String with escaped character: \\\" \" \n" +
						  "}"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertNotNil(context)
		XCTAssert(context.allStyleDefinitions().count == 1)
		let styleDefinition = context.allStyleDefinitions()[0] as! ASTStyleDefinition
		XCTAssertEqual(styleDefinition.name, "Style")
		XCTAssert(styleDefinition.propertyDefinitionWithName("property1") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property2") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property3") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property4") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property5") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property6") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property7") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property8") != nil)
		XCTAssert(styleDefinition.propertyDefinitionWithName("property9") != nil)
	}

	func testParseEmbeddedStyle() {
		// WHEN
		let stylesheet = "Style { Embedded1 {} Embedded2 {} }"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssertEqual(context.allStyleDefinitions().count, 1)
		let styleDefinition = context.allStyleDefinitions()[0] as! ASTStyleDefinition
		XCTAssertEqual(styleDefinition.name, "Style")
		XCTAssert(styleDefinition.styleDefinitionWithName("Embedded1") != nil)
		XCTAssert(styleDefinition.styleDefinitionWithName("Embedded2") != nil)
	}
	
	func testMultipleStyles() {
		// WHEN
		let stylesheet = "Style1 {} Style2 {}"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 2)
		XCTAssert(context.definitionWithName("Style1") != nil)
		XCTAssert(context.definitionWithName("Style2") != nil)
	}
	
	func testStylesAndVariables() {
		// WHEN
		let stylesheet = "$a : 1 $b : 2 Style1 {} Style2 {}"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.allStyleDefinitions().count == 2)
		XCTAssert(context.definitionWithName("Style1") != nil)
		XCTAssert(context.definitionWithName("Style2") != nil)
		XCTAssert(context.variableWithName("a") != nil)
		XCTAssert(context.variableWithName("b") != nil)
	}
	
	func testVariableInitializationWithOtherVariable() {
		// WHEN
		let stylesheet = "$a : \"xyz\" $b : $a"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(context != nil)
		XCTAssert(context.variableWithName("a") != nil)
		XCTAssert(context.variableWithName("b") != nil)
	}

	func testUnaryMinusExpression() {
		// WHEN
		let stylesheet = "$a : 1 $b : -$a"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("b").eval() as? NSNumber, -1 as NSNumber)
	}
	
	func testAddExpression() {
		// WHEN
		let stylesheet = "$a : 1 $b : 2 $c : $a + $b"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("c").eval() as? NSNumber, 3 as NSNumber)
	}

	func testSubExpression() {
		// WHEN
		let stylesheet = "$a : 1 $b : 2 $c : $a - $b"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("c").eval() as? NSNumber, -1 as NSNumber)
	}
	
	func testMulExpression() {
		// WHEN
		let stylesheet = "$a : 3 $b : 2 $c : $a * $b"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("c").eval() as? NSNumber, 6 as NSNumber)
	}

	func testDivExpression() {
		// WHEN
		let stylesheet = "$a : 3 $b : 2 $c : $a / $b"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("c").eval() as? NSNumber, 1.5 as NSNumber)
	}

	func testExpressionPrecedence() {
		// WHEN
		let stylesheet = "$a : 1 + 2 * 3"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("a").eval() as? NSNumber, 7 as NSNumber)
	}

	func testBoxingExpression() {
		// WHEN
		let stylesheet = "$a : (1 + 2) * 3"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("a").eval() as? NSNumber, 9 as NSNumber)
	}
	
	func testTupleExpression() {
		// WHEN
		let stylesheet = "$a : (1, 2, 3, 4)"
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("a").eval() as? NSArray, [1, 2, 3, 4])
	}

	func testTupleExpressionWithReferences() {
		// WHEN
		let stylesheet = "$a : 1 $b : 2 $c : 3 $t : ($a, $a + $b, $b * $c, $c / $b)"
		
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssertEqual(context.variableWithName("t").eval() as? NSArray, [1, 3, 6, 1.5])
	}

	func testTupleAsPropertyValue() {
		// WHEN
		let stylesheet = "Style { background-color: (1, 2, 3, 4) }"
		
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		let styleDefinition:ASTStyleDefinition = context.definitionWithName("Style")
		let propertyDefinition:ASTPropertyDefinition = styleDefinition.propertyDefinitionWithName("background-color") as ASTPropertyDefinition
		XCTAssertEqual(propertyDefinition.propertyValue.eval() as? NSArray, [1, 2, 3, 4])
	}

	func testHexaValue() {
		// WHEN
		let stylesheet = "$a : #ff007f"
		
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		let variableDefinition:ASTVariable = context.variableWithName("a")
		XCTAssertEqual(variableDefinition.eval() as? NSNumber, 0xff007f)
	}

	func testColorValue() {
		// WHEN
		let stylesheet = "$a : @rgb(255,128,0) " +
						 "$b : @rgba(255, 128, 0, 255)" +
						 "$c : @RGB(255, 128, 0)" +
						 "$d : @RGBA(255, 128, 0, 255)" +
						 "$e : @RGB(#ff7f00)" +
						 "$f : @RGBA(#ff7f007f)";
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		XCTAssert(self.similarColors((context.variableWithName("a").eval() as? UIColor)!, c2:UIColor(red:255/255.0, green:128/255.0, blue:0/255.0, alpha:1.0), treshold:0.001));
		XCTAssert(self.similarColors((context.variableWithName("b").eval() as? UIColor)!, c2:UIColor(red:255/255.0, green:128/255.0, blue:0/255.0, alpha:1.0), treshold:0.001));
		XCTAssert(self.similarColors((context.variableWithName("c").eval() as? UIColor)!, c2:UIColor(red:255/255.0, green:128/255.0, blue:0/255.0, alpha:1.0), treshold:0.001));
		XCTAssert(self.similarColors((context.variableWithName("d").eval() as? UIColor)!, c2:UIColor(red:255/255.0, green:128/255.0, blue:0/255.0, alpha:1.0), treshold:0.001));
		XCTAssert(self.similarColors((context.variableWithName("e").eval() as? UIColor)!, c2:UIColor(red:0xff/255.0, green:0x7f/255.0, blue:0x00/255.0, alpha:1.0), treshold:0.001));
		XCTAssert(self.similarColors((context.variableWithName("f").eval() as? UIColor)!, c2:UIColor(red:0xff/255.0, green:0x7f/255.0, blue:0x00/255.0, alpha:0x7f/255.0), treshold:0.001));
	}
	
	func testStringEscaping() {
		// WHEN
		let stylesheet = "$a : \"bla \\n bla \\t\""
		
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		let variableDefinition:ASTVariable = context.variableWithName("a")
		XCTAssertEqual(variableDefinition.eval() as? NSString, "bla \n bla \t")
	}

	func testStringConcatenation() {
		// WHEN
		let stylesheet = "$a : \"bla\" + \"bla\""
		
		let parser = Parser.instance()
		let context = parser.parseString(stylesheet)
		
		// THEN
		let variableDefinition:ASTVariable = context.variableWithName("a")
		XCTAssertEqual(variableDefinition.eval() as? NSString, "blabla")
	}

	func testInclude() {
		// WHEN
		let stylesheet = NSBundle.mainBundle().pathForResource("test", ofType: "style");
		let parser = Parser.instance();
		let context = parser.parseFile(stylesheet)

	
		// THEN
		let styleDefinition:ASTStyleDefinition = context.definitionWithName("Style")
		let propertyDefinitionA:ASTPropertyDefinition = styleDefinition.propertyDefinitionWithName("property_a") as ASTPropertyDefinition
		XCTAssertEqual(propertyDefinitionA.propertyValue.eval() as? NSNumber, 1 as NSNumber)
		let propertyDefinitionB:ASTPropertyDefinition = styleDefinition.propertyDefinitionWithName("property_b") as ASTPropertyDefinition
		XCTAssertEqual(propertyDefinitionB.propertyValue.eval() as? NSString, "blabla")
	}
	
	// helpers
	
	func similarColors(c1:UIColor, c2:UIColor, treshold:CGFloat) -> Bool {
		var r1:CGFloat = 0, g1:CGFloat = 0, b1:CGFloat = 0, a1:CGFloat = 0;
		var r2:CGFloat = 0, g2:CGFloat = 0, b2:CGFloat = 0, a2:CGFloat = 0;
		
		c1.getRed(&r1, green:&g1, blue:&b1, alpha:&a1);
		c2.getRed(&r2, green:&g2, blue:&b2, alpha:&a2);
		
		return (fabs(r1 - r2) < treshold) &&
				(fabs(g1 - g2) < treshold) &&
				(fabs(b1 - b2) < treshold) &&
				(fabs(a1 - a2) < treshold);
	}
}
