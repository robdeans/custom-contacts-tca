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

struct ContactsRepository1 {
	var getContacts: (_ refresh: Bool) async throws -> [Contact]
	var sortContacts: (_ sortOption: Contact.SortOption) -> [Contact]
	var contact: (_ id: Contact.ID) -> Contact?

	var contactIDs: Set<Contact.ID>
	var allContactsGroup: ContactGroup
}

protocol ContactsRepository {
	func getContacts(refresh: Bool) async throws -> [Contact]
	func sortContacts(by sortOption: Contact.SortOption) -> [Contact]
	func contact(for id: Contact.ID) -> Contact?

	var contactIDs: Set<Contact.ID> { get }
	var allContactsGroup: ContactGroup { get }
}

private enum ContactsRepositoryKey: DependencyKey {
	static let liveValue: ContactsRepository = ContactsRepositoryLive()
	static let testValue: ContactsRepository = liveValue
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

extension ContactsRepository1: DependencyKey {
	static var liveValue: Self {
		@Dependency(\.contactsService) var contactsService

		return Self(
			getContacts: <#T##(Bool) async throws -> [Contact]##(Bool) async throws -> [Contact]##(_ refresh: Bool) async throws -> [Contact]#>,
			sortContacts: <#T##(Contact.SortOption) -> [Contact]##(Contact.SortOption) -> [Contact]##(_ sortOption: Contact.SortOption) -> [Contact]#>,
			contact: <#T##(Contact.ID) -> Contact?##(Contact.ID) -> Contact?##(_ id: Contact.ID) -> Contact?#>,
			contactIDs: <#T##Set<Contact.ID>#>,
			allContactsGroup: <#T##ContactGroup#>
		)
	}
	static var previewValue: Self {
		Self(
			getContacts: { _ in
				Contact.mockArray
			},
			sortContacts: { _ in
				Contact.mockArray
			},
			contact: { id in
				Contact.mockArray.first(where: { $0.id == id })
			},
			contactIDs: Set(Contact.mockArray.map { $0.id }),
			allContactsGroup: ContactGroup(
				id: "",
				name: "All Contacts",
				contactIDs: Set(Contact.mockArray.map { $0.id }),
				colorHex: ""
			)
		)
	}
}
