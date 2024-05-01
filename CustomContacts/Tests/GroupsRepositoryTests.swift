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

		// Test empty cache
		let cachedGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(cachedGroups, [])

		// Test return values
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
		let expectedGroupsTotalContacts = expectedGroups
			.map { $0.contactIDs }
			.reduce([], +)
		XCTAssert(expectedGroupsTotalContacts.count > 0)

		// Test ContactGroups are fetched
		let returnedGroups = try await groupsRepository.fetchContactGroups(refresh: true)
		XCTAssertEqual(returnedGroups, expectedGroups)
		
		// Test that Contacts are properly injected
		let returnedGroupsTotalContacts = (returnedGroups).map { $0.contactIDs }.reduce([], +)
		XCTAssert(returnedGroupsTotalContacts.count > 0)
	}
}
