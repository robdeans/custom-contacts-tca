//
//  ContactsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import CustomContactsService
import Dependencies

struct ContactsRepository {
	var getAllContacts: (_ refresh: Bool) async throws -> [Contact]
	var getContact: (_ id: Contact.ID) -> Contact?
	var contactIDs: () -> Set<Contact.ID>
	var contacts: () -> [Contact]
}

extension DependencyValues {
	var contactsRepository: ContactsRepository {
		get { self[ContactsRepository.self] }
		set { self[ContactsRepository.self] = newValue }
	}
}

extension ContactsRepository: DependencyKey {
	static var liveValue: Self {
		@Dependency(\.contactsService) var contactsService

		// swiftlint:disable identifier_name
		var _contacts: [Contact] = []
		var contactIDsSet: Set<Contact.ID> = []
		var contactDictionary: [Contact.ID: Contact] = [:]

		return Self(
			getAllContacts: { refresh in
				guard refresh else {
					return _contacts
				}
				guard try await contactsService.requestPermissions() else {
					// Permissions denied state; throw error?
					return []
				}
				_contacts = try await contactsService.fetchContacts()
				contactIDsSet = Set(_contacts.map { $0.id })
				contactDictionary = Dictionary(
					_contacts.map { ($0.id, $0) },
					uniquingKeysWith: { _, last in last }
				)
				LogInfo("Repository returning \(_contacts.count) contact(s)")
				return _contacts
			},
			getContact: { id in
				contactDictionary[id]
			},
			contactIDs: { contactIDsSet },
			contacts: { _contacts }
		)
	}
	static var testValue: Self {
		Self(
			getAllContacts: { _ in Contact.mockArray },
			getContact: { _ in Contact.mock },
			contactIDs: { [] },
			contacts: { Contact.mockArray }
		)
	}
	static var previewValue = Self.testValue
}
