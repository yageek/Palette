//
//  macOS.swift
//  Palette
//
//  Created by Yannick Heinrich on 15.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import Cocoa


class MacEncoder: PaletteWriter {

    func write(stream: OutputStream, palette: Palette) throws {

        let colorList = NSColorList(name: palette.name)

        for group in palette.groups {

            for color in group.colors {
                colorList.setColor(color.components, forKey: "\(group.name)_\(color.name)")
            }
        }

        // Create temporary directory
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try colorList.write(to: url)

        stream.open()

        defer {
            stream.close()
        }

        let read = try Data(contentsOf: url)

       let _ = read.withUnsafeBytes { stream.write($0, maxLength: read.count) }

    }
}
