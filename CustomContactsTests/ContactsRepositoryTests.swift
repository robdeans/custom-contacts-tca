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
	func testGetAllContacts() async {
		@Dependency(\.contactsRepository) var contactsRepository

		XCTAssert(contactsRepository.contacts().isEmpty)
		_ = try? await contactsRepository.getAllContacts(true)
		XCTAssertFalse(contactsRepository.contacts().isEmpty)
	}

	func testGetAllContactsError() async {
		let contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				struct SomeError: Error {}
				throw SomeError()
			}
		} operation: {
			ContactsRepository.liveValue // TODO: should this need to reference the live value?
		}

		XCTAssert(contactsRepository.contacts().isEmpty)
		_ = try? await contactsRepository.getAllContacts(true)
		XCTAssert(contactsRepository.contacts().isEmpty)
	}
}
