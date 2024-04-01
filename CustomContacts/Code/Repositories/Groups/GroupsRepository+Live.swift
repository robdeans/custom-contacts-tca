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
import GroupsService

actor GroupsRepositoryLive: GroupsRepository {
	@Dependency(\.groupsDataService) private var groupsService
	private var contactGroups: [ContactGroup] = []

	func fetchContactGroups(refresh: Bool = false) async throws -> [ContactGroup] {
		LogCurrentThread("GroupsRepositoryLive.fetchContactGroups")
		guard refresh else {
			return contactGroups
		}
		let emptyContactGroups = try await groupsService.fetchContactGroups()

		var returnedContactGroups: [ContactGroup] = []
		// TODO: handle each failure individually?
		try await withThrowingTaskGroup(of: ContactGroup.self) { group in
			LogCurrentThread("🎎 GroupsDataService withThrowingTaskGroup adding ContactGroup.init")
			for emptyGroup in emptyContactGroups {
				group.addTask {
					return await ContactGroup(emptyContactGroup: emptyGroup)
				}
			}
			LogCurrentThread("🎎 GroupsDataService withThrowingTaskGroup awaiting ContactGroups")
			for try await contactGroup in group {
				returnedContactGroups.append(contactGroup)
			}
		}

		self.contactGroups = returnedContactGroups
		return contactGroups
	}

	@discardableResult
	func createContactGroup(
		name: String,
		contacts: Set<Contact>,
		colorHex: String
	) async throws -> ContactGroup {
		LogCurrentThread("GroupsRepositoryLive.createContactGroup")

		let createdEmptyGroup = try await groupsService.createContactGroup(name, Set(contacts.map { $0.id }), colorHex)
		let createdGroup = await ContactGroup(emptyContactGroup: createdEmptyGroup)
		contactGroups.append(createdGroup)

		@Dependency(\.contactsRepository) var contactsRepository
		await contactsRepository.mergeAndSync(groups: [createdGroup])

		return createdGroup
	}
}
