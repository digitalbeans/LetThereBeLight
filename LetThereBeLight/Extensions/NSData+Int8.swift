//
//  NSData+Int8.swift
//  LetThereBeLight
//
//  Created by Dean Thibault on 11/5/17.
//  Copyright © 2017 Digital Beans. All rights reserved.
//

import Foundation

extension Data {
	static func data(withValue value: Int8) -> Data {
		var variableValue = value
		return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
	}
	
	func int8Value() -> Int8 {
		return Int8(bitPattern: self[0])
	}
	
	static func data(with character: Character) -> Data? {
		return String(character).data(using: .ascii)
	}
}
