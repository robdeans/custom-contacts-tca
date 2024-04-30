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

		let syncContactsAndGroupsTask = Task(priority: .background) {
			/// Contacts must first be fetched and assigned to respective properties
			/// so that when `ContactGroup` is fetched, `Contact` can be injected using `getContact(id:)`
			let fetchedContacts = try await fetchContactsTask.value

			let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: refresh)

			await syncContacts(with: fetchedGroups)
			return fetchedContacts
		}
		return try await syncContactsAndGroupsTask.value
	}

	func syncContacts(with contactGroups: [ContactGroup]) async {
		let emptyGroups = contactGroups.map { EmptyContactGroup(contactGroup: $0) }
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
