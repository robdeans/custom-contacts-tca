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
		/// Ensure that `contactsRepository` is empty before fetching with refresh
		let cachedContacts = try await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		/// Ensure that `contactsRepository` is populated after fetching with refresh
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
			/// Ensure the proper error is populated when Contacts permissions are not granted
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

		/// Ensure that `Contacts` have been fetched to start
		let returnedContacts = try await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)

		/// Ensure that the expected `Contact` can be retrieved
		let expectedContact = await contactsRepository.getContact(expectedID)
		XCTAssertNotNil(expectedContact)
		/// Ensure that a non-existant `Contact.ID` does not return a `Contact`
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

		/// Ensure that `Contacts` have been fetched to start
		let returnedContacts = try await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)

		let expectedContactGroups = EmptyContactGroup.mockArray
		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
			$0.groupsDataService.fetchContactGroups = {
				expectedContactGroups
			}
		} operation: {
			GroupsRepositoryKey.testValue
		}
		let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: true)

		/// Ensure that initially `returnedContacts` does not contain any `EmptyContactGroup`
		XCTAssertEqual(returnedContacts.flatMap { $0.groups }.isEmpty, true)

		await contactsRepository.syncContacts(with: fetchedGroups)

		/// Ensure that each `Contact.ID` within `expectedContactGroups` matches to a
		/// corresponding `Contact`, whose `groups` property contains the specific `EmptyContactGroup`
		for contactGroup in expectedContactGroups {
			for contactID in contactGroup.contactIDs {
				let contact = await contactsRepository.getContact(contactID)
				XCTAssertEqual(contact?.groups.contains(where: { $0 == contactGroup }), true)
			}
		}
	}
}
