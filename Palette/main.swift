//
//  main.swift
//  Palette
//
//  Created by Yannick Heinrich on 15.09.16.
//  Copyright © 2016 yageek. All rights reserved.
//

import Foundation

let InArgument = "-in";
let OutArgument = "-out";

var args  = ProcessInfo().arguments

//!MARK: - Helpers
func printUsage() {
    print("Usage: palette -in <palette_json> -out <palette_mac>")
}

func getArgumentWithOption(opt: String) -> String? {

    if let index = args.index(of:opt), args.count >= (index + 1) {
        return args[index + 1];
    }
    return nil;
}

guard let inPalette = getArgumentWithOption(opt: InArgument), let outPalette = getArgumentWithOption(opt: OutArgument) else {
    print("Error: some parameters are missing.")
    printUsage()
    exit(1)
}

guard let inStream = InputStream(fileAtPath: inPalette), let outStream = OutputStream(toFileAtPath: outPalette, append: false) else {
    print("Input our output file seems to be invalid")
    exit(1)
}

do {
    let dataIn =  try JSONDecoder().read(stream: inStream)
    try MacEncoder().write(stream: outStream, palette: dataIn)
} catch let error {
    print("An error occurs during the conversion: \(error)")
    exit(1)
}

print("Conversion was OK")
