//
//  GroupsRepository+Live.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Foundation
import GroupsService

actor GroupsRepositoryLive: GroupsRepository {
	@Dependency(\.groupsDataService) private var groupsService
	private var groupsDictionary: [ContactGroup.ID: ContactGroup] = [:]
	private var contactGroups: [ContactGroup] {
		Array(groupsDictionary.values).sorted(by: { $0.index < $1.index })
	}

	func fetchContactGroups(refresh: Bool = false) async throws -> [ContactGroup] {
		LogCurrentThread("GroupsRepositoryLive.fetchContactGroups")
		guard refresh else {
			return contactGroups
		}
		let emptyContactGroups = try await groupsService.fetchContactGroups()

		var returnedContactGroups: [ContactGroup] = []
		// TODO: handle each failure individually?
		try await withThrowingTaskGroup(of: ContactGroup.self) { group in
			LogCurrentThread("🎎 GroupsRepositoryLive withThrowingTaskGroup adding ContactGroup.init")
			for emptyGroup in emptyContactGroups {
				group.addTask {
					return await ContactGroup(emptyContactGroup: emptyGroup)
				}
			}
			LogCurrentThread("🎎 GroupsRepositoryLive withThrowingTaskGroup awaiting ContactGroups")
			for try await contactGroup in group {
				returnedContactGroups.append(contactGroup)
			}
		}

		self.groupsDictionary = Dictionary(
			returnedContactGroups.map { ($0.id, $0) },
			uniquingKeysWith: { _, last in last }
		)
		return contactGroups
	}

	@discardableResult
	func createContactGroup(
		name: String,
		contacts: Set<Contact>,
		colorHex: String
	) async throws -> ContactGroup {
		LogCurrentThread("GroupsRepositoryLive.createContactGroup")

		let createdEmptyGroup = try await groupsService.createContactGroup(
			name,
			Set(contacts.map { $0.id }),
			colorHex,
			contactGroups.count
		)
		let createdGroup = await ContactGroup(emptyContactGroup: createdEmptyGroup)
		groupsDictionary[createdGroup.id] = createdGroup

		@Dependency(\.contactsRepository) var contactsRepository
		await contactsRepository.mergeAndSync(groups: [createdGroup])

		return createdGroup
	}

	@discardableResult
	func updateContactGroup(
		id: ContactGroup.ID,
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) async throws -> ContactGroup {
		LogCurrentThread("GroupsRepositoryLive.updateContactGroup")
		guard let originalGroup = groupsDictionary[id] else {
			LogError("Could not find updated ContactGroup")
			throw GroupsRepositoryError.missingUpdatedIndex
		}

		let emptyContactGroup = try await groupsService.updateContactGroup(
			id,
			name,
			contactIDs,
			colorHex,
			originalGroup.index
		)
		let updatedContactGroup = await ContactGroup(emptyContactGroup: emptyContactGroup)

		groupsDictionary[id] = updatedContactGroup
		return updatedContactGroup
	}

	@discardableResult
	func update(origin: IndexSet, destination: Int) async throws -> [ContactGroup] {
		var contactGroupsUpdated = contactGroups
		contactGroupsUpdated.move(fromOffsets: origin, toOffset: destination)
		contactGroupsUpdated = contactGroupsUpdated.enumerated().map { index, group in
			ContactGroup(
				id: group.id,
				name: group.name,
				contacts: group.contacts,
				colorHex: group.colorHex,
				index: index
			)
		}

		// TODO: handle each failure individually?
		try await withThrowingDiscardingTaskGroup { group in
			LogCurrentThread("🧑‍🧑‍🧒‍🧒 GroupsRepositoryLive withThrowingTaskGroup updating indices")
			@Dependency(\.groupsDataService) var groupsService

			for contactGroup in contactGroupsUpdated {
				group.addTask {
					_ = try await groupsService.updateContactGroup(
						contactGroup.id,
						contactGroup.name,
						contactGroup.contactIDs,
						contactGroup.colorHex,
						contactGroup.index
					)
				}
			}
		}

		groupsDictionary = Dictionary(
			contactGroupsUpdated.map { ($0.id, $0) },
			uniquingKeysWith: { _, last in last }
		)
		return contactGroups
	}
}

extension GroupsRepositoryLive {
	enum GroupsRepositoryError: Error {
		case missingUpdatedIndex
	}
}
