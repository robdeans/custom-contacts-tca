//
//  GroupsRepositoryTests.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/30/24.
//  Copyright © 2024 RBD. All rights reserved.
//

@testable import CustomContacts
import CustomContactsModels
import CustomDump
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
		XCTAssertNoDifference(returnedGroups, expectedGroups)

		/// Ensure that `contactsRepository` contacts are properly injected
		/// by checking each `Contact.groups` contains a `EmptyContactGroup` whose `id` matches ` ContactGroup.id`
		for contactGroup in returnedGroups {
			for contactID in contactGroup.contactIDs {
				let contact = await contactsRepository.getContact(contactID)
				XCTAssertEqual(contact?.groups.contains(where: { $0.id == contactGroup.id }), true)
			}
		}

		/// Ensure that `ContactGroups` indices are correct
		XCTAssertEqual(returnedGroups.map { $0.index }.max(), returnedGroups.count - 1)
		XCTAssertEqual(Set(returnedGroups.map { $0.index }).count, returnedGroups.count)
	}

	func testCreateContactGroup() async throws {
		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		let name = "Test Group"
		let contacts = Set(Contact.mockArray)
		let colorHex = "000000"

		let originalContacts = try await contactsRepository.fetchContacts(refresh: false)
		for contact in originalContacts {
			XCTAssertTrue(contact.groups.contains(where: { $0.name == name }) == false)
		}

		let contactGroup = try await groupsRepository.createContactGroup(
			name: name,
			contacts: contacts,
			colorHex: colorHex
		)

		// Test ContactGroups indices are correct
		let returnedGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(returnedGroups.map { $0.index }.max(), returnedGroups.count - 1)
		XCTAssertEqual(Set(returnedGroups.map { $0.index }).count, returnedGroups.count)

		for contactID in contactGroup.contacts.map({ $0.id }) {
			let contact = await contactsRepository.getContact(contactID)
			XCTAssertTrue(contact?.groups.contains(where: { $0.name == name }) == true)
		}
	}

	func testUpdateContactGroup() async throws {
		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		let lastContact = Contact.mockArray.last!
		let groupContacts = Contact.mockArray.dropLast()
		let originalContactGroup = try await groupsRepository.createContactGroup(
			name: "Test Group",
			contacts: Set(groupContacts),
			colorHex: "000000"
		)

		let originalContacts = try await contactsRepository.fetchContacts(refresh: false)
		for contact in originalContacts {
			XCTAssertTrue(contact.groups.contains(where: { $0.name == name }) == false)
		}

		let updatedName = "Updated Name"
		let updateGroupName = try await groupsRepository.updateContactGroup(
			id: originalContactGroup.id,
			name: updatedName,
			contactIDs: originalContactGroup.contactIDs,
			colorHex: originalContactGroup.colorHex
		)
		XCTAssertEqual(updateGroupName.name, updatedName)
		for contact in updateGroupName.contacts {
			XCTAssertTrue(contact.groups.contains(where: { $0.name == updatedName }))
			let repoContact = await contactsRepository.getContact(contact.id)
			XCTAssertEqual(repoContact, contact)
		}

		let updatedColorHex = "FFFFFF"
		let updateGroupColorHex = try await groupsRepository.updateContactGroup(
			id: originalContactGroup.id,
			name: originalContactGroup.name,
			contactIDs: originalContactGroup.contactIDs,
			colorHex: updatedColorHex
		)
		XCTAssertEqual(updateGroupColorHex.colorHex, updatedColorHex)
		for contact in updateGroupColorHex.contacts {
			XCTAssertTrue(contact.groups.contains(where: { $0.colorHex == updatedColorHex }))
			let repoContact = await contactsRepository.getContact(contact.id)
			XCTAssertEqual(repoContact, contact)
		}

		let updatedContactIDs = originalContactGroup.contactIDs.union(Set([lastContact.id]))
		let updateGroupContactIDs = try await groupsRepository.updateContactGroup(
			id: originalContactGroup.id,
			name: originalContactGroup.name,
			contactIDs: updatedContactIDs,
			colorHex: updatedColorHex
		)
		XCTAssertEqual(updateGroupContactIDs.contactIDs, updatedContactIDs)
		for contact in updateGroupContactIDs.contacts {
			XCTAssertTrue(contact.groups.contains(where: { $0.contactIDs == updatedContactIDs }))
			let repoContact = await contactsRepository.getContact(contact.id)
			XCTAssertEqual(repoContact, contact)
		}

		// Test ContactGroups indices are correct
		let returnedGroups = try await groupsRepository.fetchContactGroups(refresh: false)
		XCTAssertEqual(returnedGroups.map { $0.index }.max(), returnedGroups.count - 1)
		XCTAssertEqual(Set(returnedGroups.map { $0.index }).count, returnedGroups.count)
	}

	func testUpdateContactGroupIndex() async throws {
		let groupsRepository = withDependencies {
			$0.contactsRepository = contactsRepository
		} operation: {
			GroupsRepositoryKey.testValue
		}

		let originalContactGroups = try await groupsRepository
			.fetchContactGroups(refresh: true)

		let originIndex = 2
		let destinationIndex = 0
		try await groupsRepository.update(origin: IndexSet(integersIn: originIndex..<(originIndex + 1)), destination: destinationIndex)

		let updatedContactGroups = try await groupsRepository
			.fetchContactGroups(refresh: false)

		let movedContactGroup = originalContactGroups[originIndex]
		var temporaryContactGroups = originalContactGroups
		temporaryContactGroups.remove(at: originIndex)
		temporaryContactGroups.insert(movedContactGroup, at: destinationIndex)
		let expectedContactGroups = temporaryContactGroups.enumerated().map {
			ContactGroup(
				id: $0.element.id,
				name: $0.element.name,
				contacts: $0.element.contacts,
				colorHex: $0.element.colorHex,
				index: $0.offset
			)
		}

		XCTAssertNoDifference(
			updatedContactGroups,
			expectedContactGroups
		)

		// TODO: check ContactsRepo sync
	}
}
