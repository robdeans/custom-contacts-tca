//
//  ContactsService.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

extension DependencyValues {
	public var contactsService: ContactsService {
		get { self[ContactsService.self] }
		set { self[ContactsService.self] = newValue }
	}
}

public struct ContactsService: Sendable {
	public var fetchContacts: @Sendable () async throws -> [Contact]
	public var requestPermissions: @Sendable () async throws -> Bool
}

extension ContactsService: DependencyKey {}
