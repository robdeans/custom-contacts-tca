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
		guard refresh || contactGroups.isEmpty else {
			return contactGroups
		}
		let emptyContactGroups = try await groupsService.fetchContactGroups()

		var returnedContactGroups: [ContactGroup] = []
		// TODO: handle each failure individually?
		try await withThrowingTaskGroup(of: ContactGroup.self) { group in
			LogCurrentThread("🧑‍🧑‍🧒‍🧒 GroupsDataService withThrowingTaskGroup getting objectIDs")
			for emptyGroup in emptyContactGroups {
				group.addTask {
					return try await Self.contactGroup(for: emptyGroup)
				}
			}
			LogCurrentThread("🧑‍🧑‍🧒‍🧒 GroupsDataService withThrowingTaskGroup awaiting ContactGroups")
			for try await contactGroup in group {
				returnedContactGroups.append(contactGroup)
			}
		}

		self.contactGroups = returnedContactGroups
		return contactGroups
	}

	func createContactGroup(
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) async throws -> ContactGroup {
		.mock//try await groupsService.createContactGroup(name, contactIDs, colorHex)
	}

	static func contactGroup(for emptyContactGroup: EmptyContactGroup) async throws -> ContactGroup {
		await ContactGroup(emptyContactGroup: emptyContactGroup)
	}
}
