//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftyUserDefaults

extension Contact {
	struct SortOption: Codable, DefaultsSerializable {
		enum Parameter: String, Codable, CaseIterable {
			case firstName
			case lastName
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

extension DefaultKeys {
	private static let contactsSortOption = "contactsSortOption"
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
}
