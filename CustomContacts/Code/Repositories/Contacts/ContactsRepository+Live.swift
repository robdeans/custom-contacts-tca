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

actor ContactsRepositoryLive {
	// Dependency needs to be at highest level to ensure testing substitution
	@Dependency(\.contactsService) private var contactsService
	@Dependency(\.groupsRepository) private var groupsRepository

	typealias ContactDictionary = [Contact.ID: Contact]
	private var contactDictionary: ContactDictionary = [:]
	private var contacts: [Contact] {
		Array(contactDictionary.values)
	}
}

extension ContactsRepositoryLive: ContactsRepository {
	func getContact(_ id: Contact.ID) -> Contact? {
		contactDictionary[id]
	}

	@discardableResult
	func fetchContacts(refresh: Bool) async throws -> [Contact] {
		LogCurrentThread("ContactsRepositoryLive.fetchContacts")
		guard refresh else {
			return contacts
		}

		guard try await contactsService.requestPermissions() else {
			throw ContactsRepositoryError.permissionDenied
		}
		let fetchContactsTask = Task(priority: .background) {
			LogCurrentThread("ContactsRepositoryLive.fetchContactsTask")

			let fetchedContacts = try await contactsService.fetchContacts()
			contactDictionary = Dictionary(
				fetchedContacts.map { ($0.id, $0) },
				uniquingKeysWith: { _, last in last }
			)
			LogInfo("Repository returning \(self.contacts.count) contact(s)")
			return fetchedContacts
		}
		return try await fetchContactsTask.value
	}

	func syncContacts(with contactGroups: [ContactGroup]) async {
		for group in contactGroups {
			let emptyGroup = EmptyContactGroup(contactGroup: group)
			for contactID in group.contactIDs {
				contactDictionary[contactID] = contactDictionary[contactID]?.adding(emptyGroup: emptyGroup)
			}
		}
	}
}

extension ContactsRepositoryLive {
	enum ContactsRepositoryError: Error {
		case permissionDenied
	}
}
