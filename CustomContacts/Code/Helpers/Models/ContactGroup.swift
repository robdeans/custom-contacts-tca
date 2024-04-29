//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies

struct ContactGroup: Sendable, Identifiable {
	typealias ID = String

	let id: ContactGroup.ID
	var name: String
	var contacts: [Contact]
	var colorHex: String
	var index: Int

	var contactIDs: Set<Contact.ID> {
		Set(contacts.map { $0.id })
	}
}

extension ContactGroup {
	init(emptyContactGroup: EmptyContactGroup) async {
		let id = emptyContactGroup.id
		let name = emptyContactGroup.name
		let colorHex = emptyContactGroup.colorHex
		let contactIDs = emptyContactGroup.contactIDs
		let index = emptyContactGroup.index

		LogCurrentThread("👯‍♀️ ContactGroup.init: \(name)")

		let returnedContacts = await withTaskGroup(of: Optional<Contact>.self) { group in
			@Dependency(\.contactsRepository) var contactsRepository
			var contacts: [Contact] = []

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
			return contacts
		}

		self.init(id: id, name: name, contacts: returnedContacts, colorHex: colorHex, index: index)
	}
}
