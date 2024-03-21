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
		XCTAssert(!viewModel.contactsSections.isEmpty)

	}

	func testLoadContactsError() async {
		let viewModel = withDependencies {
			$0.contactsService.fetchContacts = {
				struct SomeError: Error {}
				throw SomeError()
			}
		} operation: {
			ContactListView.ViewModel()
		}
		await viewModel.loadContacts(refresh: true)
		XCTAssert(viewModel.error != nil)

	}
}
