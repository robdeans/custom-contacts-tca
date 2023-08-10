//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit

extension Sequence where Element == Contact {
	func sortedByFullName() -> [Contact] {
		self.sorted { $0.fullName < $1.fullName }
	}

	func sortedByInitial() -> [Contact] {
		self.sorted {
			let firstLetter = $0.lastName.nonBlankValue ?? $0.firstName.nonBlankValue ?? ""
			let secondLetter = $1.lastName.nonBlankValue ?? $0.firstName.nonBlankValue ?? ""
			return firstLetter < secondLetter
		}
	}
}
