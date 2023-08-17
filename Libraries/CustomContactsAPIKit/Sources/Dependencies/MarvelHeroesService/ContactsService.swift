//
//  ContactsService.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Dependencies

public struct ContactsService {
	public var requestContactsPermissions: () async throws -> Bool
	public var fetchContacts: () async throws -> [Contact]
}

extension ContactsService: DependencyKey {
	public static let liveValue = ContactsService(
		requestContactsPermissions: {
			try await ContactsClientLive().getAuthorizationStatus()
		},
		fetchContacts: {
			try await ContactsClientLive().fetchContacts()
		}
	)

	private static let mockService = ContactsService(
		requestContactsPermissions: { true },
		fetchContacts: { [.mock] }
	)
	public static let previewValue = mockService
	public static let testValue = mockService
}

extension DependencyValues {
	public var contactsService: ContactsService {
		get { self[ContactsService.self] }
		set { self[ContactsService.self] = newValue }
	}
}
