//
//  ContactListViewModelTest.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

@testable import CustomContacts
import ConcurrencyExtras
import CustomContactsModels
import Dependencies
import XCTest

final class ContactListViewModelTest: XCTestCase {
	override func invokeTest() {
		withMainSerialExecutor {
			super.invokeTest()
		}
	}

	func testLoadContacts() async {
		let contactsStream = AsyncStream.makeStream(of: [Contact].self)

		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				await contactsStream.stream.first(where: { _ in true })!
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}

		let viewModel = withDependencies {
			$0.mainQueue = .immediate
			$0.contactsRepository = contactsRepository
		} operation: {
			ContactListView.ViewModel()
		}

		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)

		let loadContactsTask = Task { await viewModel.loadContacts(refresh: true) }
		await Task.yield()
		XCTAssertEqual(viewModel.isLoading, true)
		contactsStream.continuation.yield(Contact.mockArray)
		await loadContactsTask.value

		XCTAssert(!viewModel.contacts.isEmpty)
		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)
	}

	func testFetchContactsNoPermissions() async {
		let contactsRepository = withDependencies {
			$0.contactsService.requestPermissions = {
				false
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		let viewModel = withDependencies {
			$0.mainQueue = .immediate
			$0.contactsRepository = contactsRepository
		} operation: {
			ContactListView.ViewModel()
		}

		await viewModel.loadContacts(refresh: true)
		XCTAssertEqual(
			viewModel.error as? ContactsRepositoryLive.ContactsRepositoryError,
			ContactsRepositoryLive.ContactsRepositoryError.permissionDenied
		)
	}
}
