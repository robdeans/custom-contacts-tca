//
//  ContactsService.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

public protocol ContactsService {
	func fetchContacts() async throws -> [Contact]
	func requestPermissions() async throws -> Bool
}

private enum ContactsServiceKey: DependencyKey {
	static let liveValue: ContactsService = ContactsServiceLive()
	static let previewValue: ContactsService = ContactsServiceMock()
}

extension DependencyValues {
	public var contactsService: ContactsService {
		get { self[ContactsServiceKey.self] }
		set { self[ContactsServiceKey.self] = newValue }
	}
}
