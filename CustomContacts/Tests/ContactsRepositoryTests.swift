//
//  ContactsRepositoryTests.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import Dependencies
import XCTest

final class ContactsRepositoryTests: XCTestCase {
	func testFetchContacts() async throws {
		let expectedContacts = Contact.mockArray
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		let cachedContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)
	}

	func testFetchContactsNoPermissions() async {
		let contactsRepository = withDependencies {
			$0.contactsService.requestPermissions = {
				false
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		do {
			_ = try await contactsRepository.fetchContacts(refresh: true)
			XCTFail("Error needs to be thrown")
		} catch {
			XCTAssertEqual(
				error as? ContactsRepositoryLive.ContactsRepositoryError,
				ContactsRepositoryLive.ContactsRepositoryError.permissionDenied
			)
		}
	}

	func testGetContact() async throws {
		let expectedContacts = Contact.mockArray
		let expectedID = expectedContacts.first!.id
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		let cachedContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)

		let expectedContact = await contactsRepository.getContact(expectedID)
		XCTAssertNotNil(expectedContact)
		let nonexpectedContact = await contactsRepository.getContact("Not an ID")
		XCTAssertNil(nonexpectedContact)
	}

	func testContactGroupsSyncing() async throws {
		let expectedContacts = Contact.mockArray
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		let cachedContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)

		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}
		let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: true)

		XCTAssertEqual(returnedContacts.flatMap { $0.groups }.isEmpty, true)
		await contactsRepository.syncContacts(with: fetchedGroups)
		let syncedContacts = try await contactsRepository.fetchContacts(refresh: false)
		let syncedContactsGroups = syncedContacts.flatMap { $0.groups }
		XCTAssertEqual(syncedContactsGroups.isEmpty, false)
	}
}
