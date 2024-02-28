//
//  ContactsRepositoryTests.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 2/27/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
@testable import CustomContactsModels
import Dependencies
import XCTest

final class ContactsRepositoryTests: XCTestCase {
	func testGetAllContactsWithRefresh() async {
		@Dependency(\.contactsRepository) var contactsRepository

		XCTAssert(contactsRepository.contacts().isEmpty)
		_ = try? await contactsRepository.getAllContacts(true)
		XCTAssertFalse(contactsRepository.contacts().isEmpty)
	}

	func testGetLocalContacts() async {
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				[
					Contact(id: "123", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
					Contact(id: "456", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
					Contact(id: "789", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
				]

			}
		} operation: {
			ContactsRepository.testValue
		}

		XCTAssert(contactsRepository.contacts().isEmpty)

		let localContacts = try? await contactsRepository.getAllContacts(false)
		XCTAssertTrue(contactsRepository.contacts() == localContacts)
		let fetchedContacts = try? await contactsRepository.getAllContacts(true)
		XCTAssertTrue(contactsRepository.contacts() == fetchedContacts)
	}

	func testGetAllContactsError() async {
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				struct SomeError: Error {}
				throw SomeError()
			}
		} operation: {
			ContactsRepository.testValue
		}

		XCTAssert(contactsRepository.contacts().isEmpty)
		// XCTAssertThrowsError(try await contactsRepository.getAllContacts(true))

		var hasError = false
		do {
			_ = try await contactsRepository.getAllContacts(true)
		} catch {
			hasError = true
		}
		XCTAssert(hasError)
		XCTAssert(contactsRepository.contacts().isEmpty)
	}

	func testGetContactForID() async {
		let testContact = Contact(id: "000", firstName: "Test", lastName: "Lookup", displayName: "Test Lookup")
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				[
					Contact(id: "123", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
					Contact(id: "456", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
					Contact(id: "789", firstName: "Test", lastName: "Refresh", displayName: "Test Refresh"),
					testContact
				]

			}
		} operation: {
			ContactsRepository.testValue
		}

		XCTAssert(contactsRepository.contacts().isEmpty)
		XCTAssertNil(contactsRepository.getContact(testContact.id))
		_ = try? await contactsRepository.getAllContacts(true)
		XCTAssertTrue(contactsRepository.getContact(testContact.id) != nil)
		XCTAssertNil(contactsRepository.getContact("testContact.id"))
	}
}
