//
//  JSON.swift
//  Palette
//
//  Created by Yannick Heinrich on 15.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import Foundation

enum JSONError: Error {
    case BadFormat
}

class JSONEncoder: PaletteWriter {

    func write(stream: OutputStream, palette: Palette) throws {

        let groupsJSON = palette.groups.map { (group) -> (String, AnyObject) in

            let colorsJSON = group.colors.map({ (color) -> (String, String) in
                return (color.name, color.components.colorHex)
            })

            var colorDict: [String: String] = [:]
            for color in colorsJSON {
                colorDict[color.0] = color.1
            }

            return (group.name, colorDict as AnyObject)
        }

        var groupDict: [String: AnyObject] = [:]
        for group in groupsJSON {
            groupDict[group.0] = group.1
        }

        let paletteJSON = [palette.name: groupDict]

        stream.open()

        defer {
            stream.close()
        }

       var error: NSError?

       JSONSerialization.writeJSONObject(paletteJSON, to: stream, options: [], error: &error)

        if let hasError = error {
            throw hasError
        }
    }
}

class JSONDecoder: PaletteReader {

    func read(stream: InputStream) throws -> Palette {

        stream.open()

        defer {
            stream.close()
        }

        guard let json = try JSONSerialization.jsonObject(with: stream, options: []) as? [String: AnyObject] , json.count == 1, let key = json.first?.key else {
            throw JSONError.BadFormat
        }

        guard let jsonGroups = json[key] as? [String: AnyObject] else { throw JSONError.BadFormat }

        let groups = try jsonGroups.map { (tuple) -> Palette.Group in

            guard let colorsJSON = tuple.value as? [String: String] else {
                throw JSONError.BadFormat
            }

            let colors = colorsJSON.map({ (color) -> Palette.Color? in

                guard let colorValue = color.value.colorValue else { return nil }
                return Palette.Color(name: color.key, components:colorValue)
            })

            var group = Palette.Group(name: tuple.key)
            group.colors = colors.flatMap( {$0} )
            return group
        }

        var palette = Palette(name: key)
        palette.groups = groups
        return palette
    }
}
