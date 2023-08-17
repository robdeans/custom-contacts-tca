//
//  ContactsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsAPIKit
import Dependencies

protocol ContactsRepository {
	func getContacts(refresh: Bool) async throws -> [Contact]
	func contact(for id: Contact.ID) -> Contact?
}

private enum ContactsRepositoryKey: DependencyKey {
	static let liveValue: ContactsRepository = ContactsRepositoryLive()
}

extension DependencyValues {
	var contactsRepository: ContactsRepository {
		get { self[ContactsRepositoryKey.self] }
		set { self[ContactsRepositoryKey.self] = newValue }
	}
}

private final class ContactsRepositoryLive: ContactsRepository {
	@Dependency(\.contactsService) private var contactsService

	private var contacts: [Contact] = [] {
		didSet {
			// TODO: could this be a computed variable, and work when refreshing?
			contactDictionary = Dictionary(
				contacts.map { ($0.id, $0) },
				uniquingKeysWith: { _, last in last }
			)
		}
	}
	private var contactDictionary: [Contact.ID: Contact] = [:]

	private func fetchContacts() async throws -> [Contact] {
		guard try await contactsService.requestContactsPermissions() else {
			// Permissions denied state; throw error?
			return []
		}
		contacts = try await ContactsService.liveValue.fetchContacts()
		return contacts
	}

	func getContacts(refresh: Bool = false) async throws -> [Contact] {
		if refresh {
			return try await fetchContacts()
		} else {
			return contacts
		}
	}

	func contact(for id: Contact.ID) -> Contact? {
		contactDictionary[id]
	}
}
