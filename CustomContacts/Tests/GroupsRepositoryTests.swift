//
//  GroupsRepositoryTests.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/30/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import Dependencies
import XCTest

final class GroupsRepositoryTests: XCTestCase {
	private let fetchedContacts = Contact.mockArray
	private var contactsRepository: ContactsRepository!

	override func setUp() async throws {
		try await super.setUp()

		/// Ensures a clean and refreshed `contactsRepository` with the expected 
		/// fetched `Contacts` for each test
		contactsRepository = withDependencies {
			$0.contactsService.fetchContacts = {
				self.fetchedContacts
			}
		} operation: {
			ContactsRepositoryKey.testValue
		}

		_ = try await contactsRepository.fetchContacts(refresh: true)
	}

	func testFetchGroups() async throws {
		let expectedEmptyGroups = EmptyContactGroup.mockArray
		let groupsRepository = withDependencies {
			$0.groupsDataService.fetchContactGroups = {
				expectedEmptyGroups
			}
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		/// Ensure an empty starting point for fetched `ContactGroups`
		let cachedGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(cachedGroups, [])

		/// Manually generate expected return value (converting `EmptyContactGroup` to `ContactGroup`)
		var expectedGroups: [ContactGroup] = []
		for emptyGroup in expectedEmptyGroups {
			let contactGroup = await ContactGroup(
				emptyContactGroup: emptyGroup,
				getContact: { [weak self] in
					await self?.contactsRepository.getContact($0)
				}
			)
			expectedGroups.append(contactGroup)
		}

		/// Ensure that `expectedGroups.contactIDs` are populated correctly
		/// (This should already be confirmed in `ContactGroup` initializer test`)
		XCTAssertEqual(
			expectedGroups.flatMap { $0.contactIDs }.count,
			expectedEmptyGroups.flatMap { $0.contactIDs }.count
		)

		/// Ensure `ContactGroups` are fetched with refresh and match the `expectedGroups`
		let returnedGroups = try await groupsRepository.fetchContactGroups(refresh: true)
		XCTAssertEqual(returnedGroups, expectedGroups)
		
		/// Ensure that `contactsRepository` contacts are properly injected
		/// by checking each `Contact.groups` contains a `EmptyContactGroup` whose `id` matches ` ContactGroup.id`
		for contactGroup in returnedGroups {
			for contactID in contactGroup.contactIDs {
				let contact = await contactsRepository.getContact(contactID)
				XCTAssertEqual(contact?.groups.contains(where: { $0.id == contactGroup.id }), true)
			}
		}
	}
}
