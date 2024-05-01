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
	func testInitializer() async {
		let fetchedContacts = Contact.mockArray
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				fetchedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}
		_ = try! await contactsRepository.fetchContacts(refresh: true)
		let emptyContactGroup = EmptyContactGroup(
			id: "1",
			name: "Test EmptyContactGroup",
			contactIDs: [fetchedContacts.first!.id],
			colorHex: "",
			index: 0
		)

		let contactGroup = await ContactGroup(
			emptyContactGroup: emptyContactGroup,
			getContact: {
				await contactsRepository.getContact($0)
			}
		)
		XCTAssertEqual(contactGroup.contactIDs, emptyContactGroup.contactIDs)
		XCTAssertNotEqual(contactGroup.contactIDs, Set(fetchedContacts.map { $0.id }))
	}
}
