//
//  CustomContactsTest.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Dependencies
import XCTest

final class CustomContactsTest: XCTestCase {
	func testLoadContacts() async {
		let viewModel = ContactListView.ViewModel()
		await viewModel.loadContacts(refresh: true)
		XCTAssert(!viewModel.contacts.isEmpty)

	}
}
