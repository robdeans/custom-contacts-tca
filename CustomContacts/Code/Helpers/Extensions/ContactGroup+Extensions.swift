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

struct ContactGroup: Sendable, Identifiable {
	typealias ID = String

	let id: ContactGroup.ID
	var name: String
	var contacts: [Contact]
	var contactIDs: Set<Contact.ID> {
		Set(contacts.map { $0.id })
	}
	var colorHex: String
}

extension ContactGroup {
	init(id: ContactGroup.ID, name: String, contactIDs: Set<Contact.ID>, colorHex: String) async {
		@Dependency(\.contactsRepository) var contactsRepository
		var contacts: [Contact] = []

		await withTaskGroup(of: Optional<Contact>.self) { group in
			for contactID in contactIDs {
				group.addTask {
					return await contactsRepository.getContact(contactID)
				}
			}
			for await contact in group {
				if let contact {
					contacts.append(contact)
				}
			}
		}

		self.init(id: id, name: name, contacts: contacts, colorHex: colorHex)
	}
}

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
		ContactGroup(id: "1", name: "Group Name", contacts: Contact.mockArray, colorHex: "0000FF")
	}

	public static var mockArray: [ContactGroup] {
		[
			ContactGroup(id: "1", name: "Friendz", contacts: Contact.mockArray, colorHex: "0000FF"),
			ContactGroup(id: "2", name: "Enemies", contacts: Contact.mockArray, colorHex: "FF0000"),
			ContactGroup(id: "3", name: "Family", contacts: Contact.mockArray, colorHex: "00FF00"),
		]
	}
}

extension ContactGroup {
	var color: Color {
		Color(hex: colorHex)
	}

	static var empty: ContactGroup {
		@Dependency(\.uuid) var uuid
		return ContactGroup(
			id: uuid().uuidString,
			name: "",
			contacts: [],
			colorHex: Color.random.toHex ?? ""
		)
	}

	static var allContactsGroup: ContactGroup {
		@Dependency(\.contactsRepository) var contactsRepository
		return ContactGroup(
			id: "",
			name: "All Contacts",
			contacts: [], //Set(contactsRepository.getContacts().map { $0.id }),
			colorHex: ""
		)
	}
}
