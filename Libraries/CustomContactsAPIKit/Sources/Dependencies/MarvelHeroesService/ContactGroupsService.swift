//
//  ContactGroupsService.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

public struct ContactGroupsService {
	public var fetchContactGroups: () async throws -> [ContactGroup]
	public var createContactGroup: () async throws -> ContactGroup
	public var deleteContactGroup: () async throws -> Void
	public var addContactToGroup: (Contact, ContactGroup) async throws -> Void
	public var removeContactFromGroup: (Contact, ContactGroup) async throws -> Void
}

extension ContactGroupsService {
	public static let liveValue = ContactGroupsService(
		fetchContactGroups: {
			[]
		},
		createContactGroup: {
			.mock
		},
		deleteContactGroup: {},
		addContactToGroup: { _, _ in

		},
		removeContactFromGroup: { _, _ in

		}
	)
}
