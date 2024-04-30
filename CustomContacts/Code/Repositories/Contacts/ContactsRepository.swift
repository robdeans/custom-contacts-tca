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
	/// Returns an array `[Contact]`
	///
	/// If `refresh: true` the array is fetched from ContactsService, otherwise the locally stored array is provided
	func fetchContacts(refresh: Bool) async throws -> [Contact]

	/// Fetches a contact from a local dictionary; O(1) lookup time
	func getContact(_ id: Contact.ID) async -> Contact?

	/// Iterates through each `ContactGroup.contactIDs` and adds the respective group to that `Contact`
	/// found within `contactDictionary[contactID]`
	func syncContacts(with contactGroups: [ContactGroup]) async
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

	static let testValue = Self.liveValue
}
