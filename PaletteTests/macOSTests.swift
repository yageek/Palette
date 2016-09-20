//
//  macOSTests.swift
//  Palette
//
//  Created by Yannick Heinrich on 21.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import XCTest

class macOSTests: XCTestCase {

    let simplePaletteJSONFile: URL = {
        return Bundle(for: PaletteTests.self).url(forResource: "simple", withExtension: "json")!

    }()

    func testEncoding() {

        let stream = InputStream(url: simplePaletteJSONFile)!
        let palette = try! JSONDecoder().read(stream: stream)

        let out = OutputStream(toFileAtPath: "/Users/yheinrich/test.clr", append: false)!

        do {
            try MacEncoder().write(stream: out, palette: palette)
        } catch let error {
            print("Error: \(error)")
        }
    }
}
