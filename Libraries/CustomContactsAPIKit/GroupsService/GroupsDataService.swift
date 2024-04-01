//
//  GroupsDataService.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/28/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

/// Service responsible for fetching `ContactGroupData` model objects from the `GroupsDataHandler`,
/// and convert them to a `@Sendable` object such as `ContactGroup`
public struct GroupsDataService: Sendable {
	public var fetchContactGroups: @Sendable () async throws -> [EmptyContactGroup]
	public var createContactGroup: @Sendable (String, Set<Contact.ID>, String) async throws -> EmptyContactGroup
}

extension DependencyValues {
	public var groupsDataService: GroupsDataService {
		get { self[GroupsDataService.self] }
		set { self[GroupsDataService.self] = newValue }
	}
}
