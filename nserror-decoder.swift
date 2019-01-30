#!/usr/bin/env xcrun swift

import Foundation

guard CommandLine.arguments.count > 1 else {
    print("Usage:")
    print("    nserror-decoder.swift \"<data octets>\"")
    exit(1) 
}

let rawData = CommandLine.arguments[1].replacingOccurrences(of: " ", with: "")

var elements = [UInt8]()
var elementCount = 0
for (index, element) in rawData.enumerated() {
    let stringElement = String(element)
    guard let uint8Element = UInt8(stringElement, radix: 16) else {
        continue
    }
    let elementsIndex = index / 2
    if elementsIndex < elementCount {
        let updatedValue = (elements[elementsIndex] << 4) + uint8Element
        elements[elementsIndex] = updatedValue
    } else {
        elements.append(uint8Element)
        elementCount += 1
    }
}

print("\n")
print("===== Decoded Error =====")
print("\n")

let data = Data(bytes: elements)
if let result = String(data: data, encoding: .utf8) {
    print(result)
} else {
    print("Unintelligible jibberish!")
}
