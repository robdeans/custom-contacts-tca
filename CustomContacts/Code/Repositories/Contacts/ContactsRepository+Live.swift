//
//  ContactsRepository+Live.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import ContactsService
import CustomContactsHelpers
import CustomContactsModels
import Dependencies

actor ContactsRepositoryLive: ContactsRepository {
	private var contacts: [Contact] = []
	private var contactDictionary: [Contact.ID: Contact] = [:]

	/// Returns an array `[Contact]`
	///
	/// If `refresh: true` the array is fetched from ContactsService, otherwise the locally stored array is provided
	func fetchContacts(refresh: Bool) async throws -> [Contact] {
		LogCurrentThread("ContactsRepositoryLive.fetchContacts")
		guard refresh || contacts.isEmpty else {
			return contacts
		}
		@Dependency(\.contactsService) var contactsService
		guard try await contactsService.requestPermissions() else {
			// TODO: Permissions denied state; throw error?
			return []
		}
		let fetchContactsTask = Task(priority: .background) {
			LogCurrentThread("ContactsRepositoryLive.fetchContactsTask")

			// TODO: minimize re-declaration of `contactsService`?
			@Dependency(\.contactsService) var contactsService
			contacts = try await contactsService.fetchContacts()
			contactDictionary = Dictionary(
				contacts.map { ($0.id, $0) },
				uniquingKeysWith: { _, last in last }
			)
			LogInfo("Repository returning \(self.contacts.count) contact(s)")
			return contacts
		}
		return try await fetchContactsTask.value
	}

	/// Fetches a contact from a local dictionary; O(1) lookup time
	func getContact(_ id: Contact.ID) -> Contact? {
		contactDictionary[id]
	}
}
