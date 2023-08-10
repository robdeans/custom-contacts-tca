//
//  MarvelCharacterTests.swift
//  CustomContactsTests
//
//  Created by Aqsa Masood on 03/01/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import CustomContactsAPIKit
import XCTest

final class MarvelCharacterTests: XCTestCase {

	func testSuccessParser() {
		let json = """
		{
			"id": 1011334,
			"name": "3-D Man",
			"description": "",
			"modified": "2014-04-29T14:18:17-0400",
			"thumbnail": {
				"path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
				"extension": "jpg"
			},
		}
		""".data(using: .utf8)!

		let character = try! JSONDecoder().decode(MarvelCharacter.self, from: json)

		XCTAssertNotNil(character)
	}
}
