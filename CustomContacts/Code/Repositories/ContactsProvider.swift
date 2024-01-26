//
//  ContactsProvider.swift
//  CustomContacts
//
//  Created by Robert Deans on 1/26/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies
import SwiftyUserDefaults

struct ContactsProvider {
	var sortContacts: (_ sortOption: Contact.SortOption) -> [Contact]
	var currentSortOption: () -> Contact.SortOption
}

extension DependencyValues {
	var contactsProvider: ContactsProvider {
		get { self[ContactsProvider.self] }
		set { self[ContactsProvider.self] = newValue }
	}
}

extension ContactsProvider: DependencyKey {
	static var liveValue: ContactsProvider {
		@Dependency(\.contactsRepository) var contactsRepository
		return Self(
			sortContacts: { sortOption in
				Defaults[\.contactsSortOption] = sortOption
				return contactsRepository.contacts().sorted(by: sortOption)
			},
			currentSortOption: { Defaults[\.contactsSortOption] }
		)
	}
}

extension Contact.SortOption: DefaultsSerializable {}

extension DefaultsKeys {
	fileprivate var contactsSortOption: DefaultsKey<Contact.SortOption> {
		.init(
			"contactsSortOption",
			defaultValue: Contact.SortOption(parameter: .lastName, ascending: true)
		)
	}
}
