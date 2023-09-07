//
//  GroupsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsAPIKit
import Dependencies
import SwiftData

protocol GroupsRepository {
	func fetchGroups() throws -> [ContactGroup]
	func addGroup(_ group: ContactGroup) throws
	func removeGroup(_ group: ContactGroup) throws
}

private enum GroupsRepositoryKey: DependencyKey {
	static let liveValue: GroupsRepository = GroupsRepositoryLive()
	static let previewValue: GroupsRepository = GroupsRepositoryPreview()
}

extension DependencyValues {
	var groupsRepository: GroupsRepository {
		get { self[GroupsRepositoryKey.self] }
		set { self[GroupsRepositoryKey.self] = newValue }
	}
}

private final class GroupsRepositoryLive: GroupsRepository {
	private let container: ModelContainer
	private var groups: [ContactGroup] = []

	init() {
		container = try! ModelContainer(for: ContactGroup.self)
	}

	@MainActor func fetchGroups() throws -> [ContactGroup] {
		groups = try container.mainContext.fetch(FetchDescriptor<ContactGroup>())
		return groups
	}

	@MainActor func addGroup(_ group: ContactGroup) throws {
		container.mainContext.insert(group)
		try container.mainContext.save()
	}

	@MainActor func removeGroup(_ group: ContactGroup) throws {
		container.mainContext.delete(group)
		try container.mainContext.save()
	}
}

private final class GroupsRepositoryPreview: GroupsRepository {
	@MainActor
	private let container: ModelContainer = {
		do {
			let container = try ModelContainer(for: ContactGroup.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
			container.mainContext.insert(ContactGroup.mock)
			return container
		} catch {
			fatalError("Failed to create container")
		}
	}()

	@MainActor func fetchGroups() throws -> [ContactGroup] {
		try container.mainContext.fetch(FetchDescriptor<ContactGroup>())
	}

	@MainActor func addGroup(_ group: ContactGroup) {
		container.mainContext.insert(group)
	}

	@MainActor func removeGroup(_ group: ContactGroup) {
		container.mainContext.delete(group)
	}
}
