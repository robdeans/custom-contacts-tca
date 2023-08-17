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
import Foundation

protocol ContactsRepository {
	func getContacts(refresh: Bool) async throws -> [Contact]
	func contact(for id: Contact.ID) -> Contact?
	func sortContacts(by sortOption: Contact.SortOption) -> [Contact]
}

private enum ContactsRepositoryKey: DependencyKey {
	static let liveValue: ContactsRepository = ContactsRepositoryLive()
	static let previewValue: ContactsRepository = ContactsRepositoryPreview()
}

extension DependencyValues {
	var contactsRepository: ContactsRepository {
		get { self[ContactsRepositoryKey.self] }
		set { self[ContactsRepositoryKey.self] = newValue }
	}
}

private final class ContactsRepositoryLive: ContactsRepository {
	@Dependency(\.contactsService) private var contactsService

	private var contacts: [Contact] = []
	private var contactDictionary: [Contact.ID: Contact] = [:]
	// TODO: @Dependency here
	private var sortOption = Contact.SortOption.current {
		didSet {
			contacts = contacts.sorted(by: sortOption)
		}
	}

	private func fetchContacts() async throws -> [Contact] {
		guard try await contactsService.requestContactsPermissions() else {
			// Permissions denied state; throw error?
			return []
		}
		contacts = try await ContactsService.liveValue.fetchContacts()
			.sorted(by: sortOption)
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
		UserDefaults.standard.set(sortOption.rawValue, forKey: DefaultKeys.contactsSortOption)
		return contacts
	}
}

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
}
