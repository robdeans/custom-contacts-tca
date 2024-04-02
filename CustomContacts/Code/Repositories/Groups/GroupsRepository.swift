//
//  GroupsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies
import Foundation

// TODO: add a refresh stream once AsyncStream can be adopted within an actor
// https://forums.swift.org/t/asyncstream-and-actors/70545/2

protocol GroupsRepository: Sendable {
	func fetchContactGroups(refresh: Bool) async throws -> [ContactGroup]

	@discardableResult
	func createContactGroup(name: String, contacts: Set<Contact>, colorHex: String) async throws -> ContactGroup

	@discardableResult
	func updateContactGroup(id: ContactGroup.ID, name: String, contactIDs: Set<Contact.ID>, colorHex: String) async throws -> ContactGroup

	@discardableResult
	func update(origin: IndexSet, destination: Int) async throws -> [ContactGroup]
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
