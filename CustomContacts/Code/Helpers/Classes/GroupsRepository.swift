//
//  GroupsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsAPIKit
import CustomContactsHelpers
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
		do {
			container = try ModelContainer(for: ContactGroup.self)
		} catch {
			// TODO: how should this be handled?
			LogFatal("Failed to initialize ContactGroup container")
		}
	}

	@MainActor func fetchGroups() throws -> [ContactGroup] {
		do {
			groups = try container.mainContext.fetch(FetchDescriptor<ContactGroup>())
			return groups
		} catch {
			LogError(error.localizedDescription)
			throw GroupsError.failedFetch
		}
	}

	@MainActor func addGroup(_ group: ContactGroup) throws {
		do {
			container.mainContext.insert(group)
			try container.mainContext.save()
		} catch {
			LogError(error.localizedDescription)
			throw GroupsError.failedAdd
		}
	}

	@MainActor func removeGroup(_ group: ContactGroup) throws {
		do {
			container.mainContext.delete(group)
			try container.mainContext.save()
		} catch {
			LogError(error.localizedDescription)
			throw GroupsError.failedRemove
		}
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

// TODO: expand
enum GroupsError: Error {
	case failedFetch
	case failedAdd
	case failedRemove
}

extension GroupsError: DisplayableSwiftError {
	var title: String? {
		nil
	}

	var message: String? {
		switch self {
		case .failedFetch:
			return "Failed to fetch groups."
		case .failedAdd:
			return "Failed to add group."
		case .failedRemove:
			return "Failed to remove group."
		}
	}

	var buttonTitle: String? {
		nil
	}
}
