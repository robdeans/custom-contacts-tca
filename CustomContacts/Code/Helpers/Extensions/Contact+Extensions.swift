//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

extension Contact.SortOption {
	static var current: Contact.SortOption {
		@Dependency(\.contactsProvider) var contactsProvider
		return contactsProvider.currentSortOption()
	}
}

extension Sequence where Element == Contact {
	func sorted(by sortOption: Contact.SortOption = .current) -> [Contact] {
		switch sortOption.parameter {
		case .firstName:
			return self.sorted {
				sortOption.ascending ? $0.firstName < $1.firstName
				: $0.firstName > $1.firstName
			}
		case .lastName:
			return self.sorted {
				sortOption.ascending ? $0.lastName < $1.lastName
				: $0.lastName > $1.lastName
			}
		}
	}

	func filter(searchText: String) -> [Contact] {
		if !searchText.isEmpty {
			return self.filter {
				$0.displayName.lowercased().contains(searchText.lowercased())
			}
		}
		return self.map { $0 as Contact }
	}
}

extension Sequence where Element == (String, [Contact]) {
	func sorted(by sortOption: Contact.SortOption = .current) -> [(String, [Contact])] {
		switch sortOption.parameter {
		case .firstName:
			return self.sorted {
				sortOption.ascending ? $0.0 < $1.0
				: $0.0 > $1.0
			}
			.map { ($0.0, $0.1.sorted()) }
		case .lastName:
			return self.sorted {
				sortOption.ascending ? $0.0 < $1.0
				: $0.0 > $1.0
			}
			.map { ($0.0, $0.1.sorted()) }
		}
	}
}
