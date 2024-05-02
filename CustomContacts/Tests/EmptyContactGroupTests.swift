//
//  EmptyContactGroupTests.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 5/1/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import Dependencies
import XCTest

final class EmptyContactGroupTests: XCTestCase {
	func testInitializer() {
		let contactGroup = ContactGroup.mock
		let emptyContactGroup = EmptyContactGroup(contactGroup: contactGroup)
		XCTAssertEqual(contactGroup.id, emptyContactGroup.id)
		XCTAssertEqual(contactGroup.name, emptyContactGroup.name)
		XCTAssertEqual(contactGroup.contactIDs, emptyContactGroup.contactIDs)
		XCTAssertEqual(contactGroup.colorHex, emptyContactGroup.colorHex)
		XCTAssertEqual(contactGroup.index, emptyContactGroup.index)
	}
}
