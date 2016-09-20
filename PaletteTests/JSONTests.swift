//
//  JSONTests.swift
//  Palette
//
//  Created by Yannick Heinrich on 15.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import XCTest


class JSONTests: XCTestCase {
    let simplePaletteJSONFile: URL = {
        return Bundle(for: PaletteTests.self).url(forResource: "simple", withExtension: "json")!

    }()

    func testEquality() {
        let stream = InputStream(url: simplePaletteJSONFile)!
        let palette = try! JSONDecoder().read(stream: stream)

        XCTAssertTrue(palette == palette)

    }

    func testJSONRead() {

        let stream = InputStream(url: simplePaletteJSONFile)!

        do {
            let palette = try JSONDecoder().read(stream: stream)

            XCTAssertEqual(palette.name, "A Simple palette")
            XCTAssertEqual(palette.groups.count, 2)

            let firstGroup = palette.groups[0]

            XCTAssertEqual(firstGroup.name, "group 1")
            XCTAssertEqual(firstGroup.colors.count, 3)


            let secondGroup = palette.groups[1]

            XCTAssertEqual(secondGroup.name, "group 2")
            XCTAssertEqual(secondGroup.colors.count, 2)

        } catch let error {
            XCTFail("Error: \(error)")
        }
    }

    func testWriteJSON() {

        let stream = InputStream(url: simplePaletteJSONFile)!
        let palette = try! JSONDecoder().read(stream: stream)

        let out = OutputStream(toMemory: ())

        out.open()
        
        defer {
            out.close()
        }

        do {
            try JSONEncoder().write(stream: out, palette: palette)
            // Read it again and compare
            guard let buffer = out.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
                XCTFail("Can not retrieve data")
                return
            }
            
            let reread = InputStream(data: buffer)
            let rePalette = try JSONDecoder().read(stream: reread)
            XCTAssertEqual(rePalette, palette)

        } catch let error {
            XCTFail("Error: \(error)")
        }

    }
    
}
