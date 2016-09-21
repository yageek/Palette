//
//  Palette.swift
//  Palette
//
//  Created by Yannick Heinrich on 14.09.16.
//
//

import Cocoa

/// Palette represents a palette
public struct Palette {
    public var groups: [Group] = []
    var name: String

    init(name: String) {
        self.name = name
    }

    public struct Group {
        var name: String
        var colors: [Color] = []

        init(name: String) {
            self.name = name
        }
    }

    public struct Color {
        var name: String
        var components: NSColor

        init(name: String, components: NSColor) {
            self.name = name
            self.components = components
        }
    }
}


/// A PaletteWriter is able to write a palette in a stream.
protocol PaletteWriter {
    func write(stream: OutputStream, palette: Palette) throws
}

/// A PaletteReader is able to read a palette from a stream.
protocol PaletteReader {
    func read(stream: InputStream) throws -> Palette
}

//!MARK: - Equatable implementation
extension Palette: Equatable {}
extension Palette.Group: Equatable {}
extension Palette.Color: Equatable {}

public func ==(lhs: Palette.Color, rhs: Palette.Color) -> Bool {
    return lhs.name == rhs.name && lhs.components.isEqual(rhs.components)
}
public func ==(lhs: Palette.Group, rhs: Palette.Group) -> Bool {
    guard lhs.name == rhs.name  && lhs.colors.count == rhs.colors.count else { return false }

    for color in lhs.colors {
        guard rhs.colors.contains(color) else { return false }
    }
    return true
}

public func ==(lhs: Palette, rhs: Palette) -> Bool {

    guard lhs.name == rhs.name else { return false }
    guard lhs.groups.count == rhs.groups.count else { return false }

    for group in lhs.groups {
        guard rhs.groups.contains(group) else { return false }
    }

    return true
}
