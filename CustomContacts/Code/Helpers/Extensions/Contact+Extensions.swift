//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftyUserDefaults

extension Contact {
	struct SortOption: Codable, DefaultsSerializable {
		enum Parameter: String, Codable, CaseIterable {
			/// silences swiftlint warning `raw_value_for_camel_cased_codable_enum`
			case firstName = "first_name"
			case lastName = "last_name"
		}
		var parameter: Parameter
		var ascending: Bool

		static var current: SortOption {
			Defaults[\.contactsSortOption]
		}
	}
}

extension DefaultsKeys {
	var contactsSortOption: DefaultsKey<Contact.SortOption> {
		.init("contactsSortOption", defaultValue: Contact.SortOption(parameter: .lastName, ascending: true))
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
