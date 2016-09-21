//
//  ColorsConversionTests.swift
//  Palette
//
//  Created by Yannick Heinrich on 20.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import XCTest

class ColorsConversionTests: XCTestCase {

    func testColorValue() {

        XCTAssertNotNil("#FF0000".colorValue)
        XCTAssertNotNil("#FF0".colorValue)
        XCTAssertNotNil("#FF000000".colorValue)

        XCTAssertNotNil("FF000000".colorValue)
        XCTAssertNotNil("FF0000".colorValue)
        XCTAssertNotNil("FF0".colorValue)

        XCTAssertNil("qwe".colorValue)
        XCTAssertNil("#1".colorValue)
        XCTAssertNil("#12".colorValue)

        XCTAssertEqual("FF0000".colorValue!, NSColor.red)
        XCTAssertEqual("00FF00".colorValue!, NSColor.green)
        XCTAssertEqual("0000FF".colorValue!, NSColor.blue)

    }

    func testColorHex() {

        XCTAssertEqual(NSColor.red.colorHex, "#FF0000FF")
        XCTAssertEqual(NSColor.green.colorHex, "#00FF00FF")
        XCTAssertEqual(NSColor.blue.colorHex, "#0000FFFF")
    }

}
