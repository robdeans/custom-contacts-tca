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
	private var contacts: [Contact] {
		Array(contactDictionary.values)
	}
	private var contactDictionary: [Contact.ID: Contact] = [:]

	func fetchContacts(refresh: Bool) async throws -> [Contact] {
		LogCurrentThread("ContactsRepositoryLive.fetchContacts")
		guard refresh else {
			return contacts
		}
		@Dependency(\.contactsService) var contactsService
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
			return contacts
		}
		return try await fetchContactsTask.value
	}

	func getContact(_ id: Contact.ID) -> Contact? {
		contactDictionary[id]
	}

	func mergeAndSync(groups: [ContactGroup]) async {
		let emptyGroups = groups.map { EmptyContactGroup(contactGroup: $0) }
		for group in emptyGroups {
			for contactID in group.contactIDs {
				contactDictionary[contactID] = contactDictionary[contactID]?.adding(group: group)
			}
		}
	}
}

extension ContactsRepositoryLive {
	enum ContactsRepositoryError: Error {
		case permissionDenied
	}
}
