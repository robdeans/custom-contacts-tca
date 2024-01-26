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
	var filterContacts: ([FilterQuery]) -> [Contact]
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
			filterContacts: { filterQueries in
				// Given the switch case and usage of Set methods, this could be more efficient.
				// TODO: re-test with larger contacts data set and
				// TODO: add test coverage

				var filteredContactIDs = Set<Contact.ID>()
				if !filterQueries.isEmpty {
					filterQueries.forEach {
						switch $0.logic {
						case .and:
							switch $0.filter {
							case .include:
								filteredContactIDs.formIntersection($0.group.contactIDs)
							case .exclude:
								var allContactIDsExcludingGroup = contactsRepository.contactIDs()
								$0.group.contactIDs.forEach {
									filteredContactIDs.remove($0)
									allContactIDsExcludingGroup.remove($0)
								}
								filteredContactIDs.formUnion(allContactIDsExcludingGroup)
							}
						case .or:
							switch $0.filter {
							case .include:
								filteredContactIDs.formUnion($0.group.contactIDs)
							case .exclude:
								var allContactIDsExcludingGroup = contactsRepository.contactIDs()
								$0.group.contactIDs.forEach {
									allContactIDsExcludingGroup.remove($0)
								}
								filteredContactIDs.formUnion(allContactIDsExcludingGroup)
							}
						}
					}
				} else {
					filteredContactIDs = contactsRepository.contactIDs()
				}

				return filteredContactIDs
					.compactMap(contactsRepository.getContact)
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
