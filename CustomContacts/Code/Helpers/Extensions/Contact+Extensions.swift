//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit

extension Contact {
	enum SortOption {
		case firstName(ascending: Bool = true)
		case lastName(ascending: Bool = true)

		init?(_ rawValue: String) {
			switch rawValue {
			case "firstNameAscending":
				self = .firstName(ascending: true)
			case "firstNameDescending":
				self = .firstName(ascending: false)
			case "lastNameAscending":
				self = .lastName(ascending: true)
			case "lastNameDescending":
				self = .lastName(ascending: false)
			default:
				return nil
			}
		}

		var rawValue: String {
			switch self {
			case .firstName(ascending: let ascending):
				return ascending ? "firstNameAscending" : "firstNameDescending"
			case .lastName(ascending: let ascending):
				return ascending ? "lastNameAscending" : "lastNameDescending"
			}
		}
	}
}

extension Sequence where Element == Contact {
	func sorted(by sortOption: Contact.SortOption) -> [Contact] {
		switch sortOption {
		case let .firstName(ascending):
			return self.sorted {
				ascending ? $0.firstName < $1.firstName
				: $0.firstName > $1.firstName
			}
		case let .lastName(ascending):
			return self.sorted {
				ascending ? $0.lastName < $1.lastName
				: $0.lastName > $1.lastName
			}
		}
	}
}
