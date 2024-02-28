//
//  ContactListViewModelTest.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

@testable import CustomContacts
@testable import CustomContactsModels
import Dependencies
import XCTest

final class ContactListViewModelTest: XCTestCase {
	func testLoadContacts() async {
		let viewModel = withDependencies {
			$0.contactsService.fetchContacts = {
				return Contact.mockArray
			}
		} operation: {
			ContactListView.ViewModel()
		}

		XCTAssertTrue(viewModel.contacts.isEmpty)
		XCTAssertTrue(viewModel.error == nil)
		XCTAssertFalse(viewModel.isLoading)
		
		await viewModel.loadContacts(refresh: true)
		
		XCTAssertFalse(viewModel.isLoading)
		XCTAssertTrue(viewModel.error == nil)
		XCTAssertEqual(viewModel.contacts, Contact.mockArray)
	}

	func testLoadContactsError() async {
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				struct SomeError: Error {}
				throw SomeError()
			}
		} operation: {
			ContactsRepository.testValue
		}
		let viewModel = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			ContactListView.ViewModel()
		}
		XCTAssert(contactsRepository.contacts().isEmpty)
		await viewModel.loadContacts(refresh: true)
		XCTAssert(viewModel.error != nil)
	}

	func testIsLoadingIndicator() async {
		var testIsLoading: (() -> Void)?
		let viewModel = withDependencies {
			$0.contactsRepository.getAllContacts = { _ in
				testIsLoading?()
				return Contact.mockArray
			}
		} operation: {
			ContactListView.ViewModel()
		}
		var didTestLoad = false
		testIsLoading = { [weak viewModel] in
			didTestLoad = true
			XCTAssertTrue(viewModel!.isLoading)
		}

		XCTAssertFalse(viewModel.isLoading)
		await viewModel.loadContacts(refresh: true)
		XCTAssertFalse(viewModel.isLoading)

		XCTAssertTrue(didTestLoad)
	}
}
