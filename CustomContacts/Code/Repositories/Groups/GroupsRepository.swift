//
//  GroupsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

protocol GroupsRepository: Sendable {
	func fetchContactGroups(refresh: Bool) async throws -> [ContactGroup]
	func createContactGroup(name: String, contactIDs: Set<Contact.ID>, colorHex: String) async throws -> ContactGroup
}

private enum GroupsRepositoryKey: DependencyKey {
	static var liveValue: GroupsRepository {
		GroupsRepositoryLive()
	}
}
extension DependencyValues {
	var groupsRepository: GroupsRepository {
		get { self[GroupsRepositoryKey.self] }
		set { self[GroupsRepositoryKey.self] = newValue }
	}
}
