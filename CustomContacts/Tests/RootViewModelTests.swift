//
//  RootViewModelTests.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 5/1/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import ConcurrencyExtras
import CustomContactsModels
import Dependencies
import XCTest

final class RootViewModelTests: XCTestCase {
	override func invokeTest() {
		/// Allows tests to run in serial order so that Task operations can be
		/// suspended and `isLoading` states observed
		withMainSerialExecutor {
			super.invokeTest()
		}
	}

	@MainActor
	func testAppInitialization() async throws {
		let contactsStream = AsyncStream.makeStream(of: [Contact].self)
		let expectedContacts = Contact.mockArray
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				await contactsStream.stream.first(where: { _ in true })!
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}

		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		let viewModel = withDependencies {
			$0.contactsRepository = contactsRepository
			$0.groupsRepository = groupsRepository
		} operation: {
			RootView.ViewModel()
		}

		/// Ensure initial caches of `Contact` and `ContactGroup` are empty
		let initialContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(initialContacts, [])
		let initialGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(initialGroups, [])
		
		/// Ensure initial state of `isLoading` and `error` is correct
		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)

		let initializeAppTask = Task { await viewModel.initializeApp() }
		await Task.yield()

		/// Ensure that `isLoading` is correctly set while operation is executing
		XCTAssertEqual(viewModel.isLoading, true)
		contactsStream.continuation.yield(expectedContacts)
		await initializeAppTask.value

		/// Ensure end state of `isLoading` and `error` is correct
		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)

		/// Ensure end caches of `Contact` and `ContactGroup` have been populated.
		/// Checks for syncing are handled in each respective Repository test file.
		let updatedContacts = try await contactsRepository.fetchContacts(refresh: false)
		let updatedGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(updatedContacts.isEmpty, false)
		XCTAssertEqual(updatedGroups.isEmpty, false)
	}

	@MainActor
	func testAppInitializationError() async throws {
		struct TestError: Error {}

		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				throw TestError()
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}

		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		let viewModel = withDependencies {
			$0.contactsRepository = contactsRepository
			$0.groupsRepository = groupsRepository
		} operation: {
			RootView.ViewModel()
		}

		await viewModel.initializeApp()

		/// Ensure that error is populated from `contactsService`
		XCTAssertNotNil(viewModel.error)
	}
}
