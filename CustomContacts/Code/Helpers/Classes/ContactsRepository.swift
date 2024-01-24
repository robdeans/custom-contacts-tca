//
//  ContactsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsModels
import CustomContactsService
import Dependencies
import SwiftyUserDefaults

protocol ContactsRepository {
	func getContacts(refresh: Bool) async throws -> [Contact]
	func sortContacts(by sortOption: Contact.SortOption) -> [Contact]
	func contact(for id: Contact.ID) -> Contact?

	var contactIDs: Set<Contact.ID> { get }
	var allContactsGroup: ContactGroup { get }
}

private enum ContactsRepositoryKey: DependencyKey {
	static let liveValue: ContactsRepository = ContactsRepositoryLive()
	static let previewValue: ContactsRepository = ContactsRepositoryPreview()
	static let testValue: ContactsRepository = ContactsRepositoryPreview()
}

extension DependencyValues {
	var contactsRepository: ContactsRepository {
		get { self[ContactsRepositoryKey.self] }
		set { self[ContactsRepositoryKey.self] = newValue }
	}
}

// MARK: - Live Repo
private final class ContactsRepositoryLive: ContactsRepository {
	@Dependency(\.contactsService) private var contactsService

	var allContactsGroup: ContactGroup {
		ContactGroup(id: "", name: "All Contacts", contactIDs: contactIDs, colorHex: "")
	}

	private var contacts: [Contact] = []
	private(set) var contactIDs: Set<Contact.ID> = []
	private var contactDictionary: [Contact.ID: Contact] = [:]
	private var sortOption = Contact.SortOption.current {
		didSet {
			contacts = contacts.sorted(by: sortOption)
		}
	}

	private func fetchContacts() async throws -> [Contact] {
		guard try await contactsService.requestPermissions() else {
			// Permissions denied state; throw error?
			return []
		}
		contacts = try await contactsService.fetchContacts()
			.sorted(by: sortOption)
		contactIDs = Set(contacts.map { $0.id })
		contactDictionary = Dictionary(
			contacts.map { ($0.id, $0) },
			uniquingKeysWith: { _, last in last }
		)
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

	@discardableResult
	func sortContacts(by sortOption: Contact.SortOption) -> [Contact] {
		self.sortOption = sortOption
		Defaults[\.contactsSortOption] = sortOption
		return contacts
	}
}

// MARK: - Previews Repo
private final class ContactsRepositoryPreview: ContactsRepository {
	func getContacts(refresh: Bool) async throws -> [Contact] {
		Contact.mockArray
	}

	func contact(for id: Contact.ID) -> Contact? {
		Contact.mockArray.first(where: { $0.id == id })
	}

	func sortContacts(by sortOption: Contact.SortOption) -> [Contact] {
		Contact.mockArray
	}

	var contactIDs: Set<Contact.ID> {
		Set(Contact.mockArray.map { $0.id })
	}

	var allContactsGroup: ContactGroup {
		ContactGroup(id: "", name: "All Contacts", contactIDs: contactIDs, colorHex: "")
	}
}
