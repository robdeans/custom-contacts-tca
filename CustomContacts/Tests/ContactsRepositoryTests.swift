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
	func testFetchContacts() async {
		let expectedContacts = Contact.mockArray
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts =  {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.liveValue
		}
		let cachedContacts = try? await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try? await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)
	}

	func testFetchContactsNoPermissions() async {
		let contactsRepository = withDependencies {
			$0.contactsService.requestPermissions =  { 
				false
			}
		} operation: {
			ContactsRepositoryKey.liveValue
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

	func testGetContact() async {
		let expectedContacts = Contact.mockArray
		let expectedID = expectedContacts.first!.id
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts =  {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.liveValue
		}
		let cachedContacts = try? await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try? await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)

		let expectedContact = await contactsRepository.getContact(expectedID)
		XCTAssertNotNil(expectedContact)
		let nonexpectedContact = await contactsRepository.getContact("Not an ID")
		XCTAssertNil(nonexpectedContact)
	}

	func testContactGroups() async {
		// TODO: enable test substitution for GroupsRepository
		let expectedContacts = Contact.mockArray
//		let expectedIDs = expectedContacts.map { $0.id }
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts =  {
				expectedContacts
			}
		} operation: {
			ContactsRepositoryKey.liveValue
		}
		let cachedContacts = try? await contactsRepository.fetchContacts(refresh: false)
		XCTAssertEqual(cachedContacts, [])

		let returnedContacts = try? await contactsRepository.fetchContacts(refresh: true)
		XCTAssertEqual(returnedContacts, expectedContacts)
	}
}
