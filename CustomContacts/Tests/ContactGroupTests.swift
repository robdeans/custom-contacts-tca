//
//  ContactGroupTests.swift
//  CustomContactsTests
//
//  Created by Robert Deans on 4/30/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import Dependencies
import XCTest

final class ContactGroupTests: XCTestCase {
	func testInitializer() async throws {
		let fetchedContacts = Contact.mockArray
		let contactIDs = fetchedContacts.first!.id
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				fetchedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		_ = try await contactsRepository.fetchContacts(refresh: true)

		let emptyContactGroup = EmptyContactGroup(
			id: "1",
			name: "Test EmptyContactGroup",
			contactIDs: [contactIDs],
			colorHex: "",
			index: 0
		)

		let contactGroup = await ContactGroup(
			emptyContactGroup: emptyContactGroup,
			getContact: {
				await contactsRepository.getContact($0)
			}
		)

		/// Ensure that when `ContactGroup` is initialized, the correct `Contact`s are added
		XCTAssertEqual(contactGroup.contactIDs, emptyContactGroup.contactIDs)
		XCTAssertEqual(contactGroup.contactIDs, Set([contactIDs]))
	}

	func testInitializerWarning() async throws {
		let fetchedContacts = Contact.mockArray
		let emptyContactGroup = EmptyContactGroup(
			id: "1",
			name: "Test EmptyContactGroup",
			contactIDs: [fetchedContacts.first!.id, fetchedContacts.last!.id],
			colorHex: "",
			index: 0
		)

		let contactGroup1 = await ContactGroup(
			emptyContactGroup: emptyContactGroup,
			getContact: { _ in nil }
		)
		XCTAssertEqual(contactGroup1.contactIDs, [])
	}
}
