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

		let initialContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(initialContacts, [])
		let initialGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(initialGroups, [])

		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)

		let initializeAppTask = Task { await viewModel.initializeApp() }
		await Task.yield()
		XCTAssertEqual(viewModel.isLoading, true)
		contactsStream.continuation.yield(expectedContacts)
		await initializeAppTask.value

		XCTAssertEqual(viewModel.isLoading, false)
		XCTAssertNil(viewModel.error)

		let updatedContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(updatedContacts.flatMap { $0.groups }.isEmpty, false)
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

		XCTAssertNotNil(viewModel.error)
	}
}
