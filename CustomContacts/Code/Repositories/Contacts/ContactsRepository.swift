//
//  ContactsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

protocol ContactsRepository: Sendable {
	func fetchContacts(refresh: Bool) async throws -> [Contact]
	func getContact(_ id: Contact.ID) async -> Contact?
	func mergeAndSync(groups: [ContactGroup]) async
}

extension DependencyValues {
	var contactsRepository: ContactsRepository {
		get { self[ContactsRepositoryKey.self] }
		set { self[ContactsRepositoryKey.self] = newValue }
	}
}

private enum ContactsRepositoryKey: DependencyKey {
	static var liveValue: ContactsRepository {
		ContactsRepositoryLive()
	}
}
