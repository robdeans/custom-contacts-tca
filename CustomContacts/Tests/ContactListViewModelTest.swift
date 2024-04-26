//
//  ContactListViewModelTest.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import Dependencies
import XCTest

final class ContactListViewModelTest: XCTestCase {
	@MainActor
	func testLoadContacts() async {
		let viewModel = withDependencies {
			$0.contactsService.fetchContacts = {
				Contact.mockArray
			}
		} operation: {
			ContactListView.ViewModel()
		}
		// Test isLoading??
		await viewModel.loadContacts(refresh: true)
		XCTAssert(!viewModel.contactsSections.isEmpty)
	}

	@MainActor
	func testLoadContactsError() async {
//		let viewModel = withDependencies {
//			$0.contactsService.fetchContacts = {
//				struct SomeError: Error {}
//				throw SomeError()
//			}
//		} operation: {
//			ContactListView.ViewModel()
//		}
//		await viewModel.loadContacts(refresh: true)
//		XCTAssert(viewModel.error != nil)

	}
}
