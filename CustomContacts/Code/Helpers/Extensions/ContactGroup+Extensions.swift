//
//  ContactGroup+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import SwiftUI

extension ContactGroup: Hashable {
	public static func == (lhs: ContactGroup, rhs: ContactGroup) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension ContactGroup {
	public static var mock: ContactGroup {
		ContactGroup(id: "1", name: "Group Name", contacts: Contact.mockArray, colorHex: "0000FF", index: 0)
	}

	public static var mockArray: [ContactGroup] {
		[
			ContactGroup(id: "1", name: "Friendz", contacts: Contact.mockArray, colorHex: "0000FF", index: 0),
			ContactGroup(id: "2", name: "Enemies", contacts: Contact.mockArray, colorHex: "FF0000", index: 1),
			ContactGroup(id: "3", name: "Family", contacts: Contact.mockArray, colorHex: "00FF00", index: 2),
		]
	}
}

extension ContactGroup {
	var color: Color {
		Color(hex: colorHex)
	}

	// TODO: revisit this pattern when filtering is re-introduced
	static var allContactsGroup: ContactGroup {
		@Dependency(\.contactsRepository) var contactsRepository
		return ContactGroup(
			id: "",
			name: "All Contacts",
			contacts: [], //Set(contactsRepository.getContacts().map { $0.id }),
			colorHex: "",
			index: 0
		)
	}
}
