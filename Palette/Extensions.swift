//
//  Extensions.swift
//  Palette
//
//  Created by Yannick Heinrich on 15.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import Cocoa


extension NSColor {

    private func hex(_ value: CGFloat) -> String {
        return String(format: "%02X", UInt(value * 255))
    }

    var colorHex: String {

        let red = hex(redComponent)
        let green = hex(greenComponent)
        let blue = hex(blueComponent)
        let alpha = hex(alphaComponent)

        return "#\(red)\(green)\(blue)\(alpha)"
    }
}

extension String {
    var colorValue: NSColor? {

        var hexString = uppercased()

        if hasPrefix("#") {
            let index = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            hexString = hexString.substring(from: index)
        }

        let count = hexString.characters.count

        if count == 6 {
            hexString = hexString.appending("FF")
        } else if count == 3 {
            hexString = "\(hexString)\(hexString)FF"
        }

        guard hexString.characters.count == 8 else { return nil }

        let scan = Scanner(string: hexString)

        var colorValue: UInt32 = 0
        guard scan.scanHexInt32(&colorValue) else { return nil }


        let red = (colorValue >> 24) & 0xFF
        let green = (colorValue >> 16) & 0xFF
        let blue = (colorValue >> 8) & 0xFF
        let alpha = colorValue & 0xFF

        return NSColor(calibratedRed: red.colorComponent, green: green.colorComponent, blue: blue.colorComponent, alpha: alpha.colorComponent)

    }
}

private extension UInt32 {
    var colorComponent: CGFloat {

        return CGFloat(self) / 255.0
    }
}
