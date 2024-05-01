//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels

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
	init(
		emptyContactGroup: EmptyContactGroup,
		getContact: @Sendable @escaping (_ id: Contact.ID) async -> Contact?
	) async {
		let id = emptyContactGroup.id
		let name = emptyContactGroup.name
		let colorHex = emptyContactGroup.colorHex
		let contactIDs = emptyContactGroup.contactIDs
		let index = emptyContactGroup.index

		LogCurrentThread("👯‍♀️ ContactGroup.init: \(name)")

		let returnedContacts = await withTaskGroup(of: Optional<Contact>.self) { taskGroup in
			var contacts: [Contact] = []

			for contactID in contactIDs {
				taskGroup.addTask {
					let contact = await getContact(contactID)
					return contact?.sync(emptyGroup: emptyContactGroup)
				}
			}
			for await contact in taskGroup {
				if let contact {
					contacts.append(contact)
				}
			}
			return contacts
		}
		if returnedContacts.count != contactIDs.count {
			if !contactIDs.isEmpty && returnedContacts.isEmpty {
				LogWarning("No Contacts were added to ContactGroup; has the ContactsRepository fetched Contacts?")
			} else {
				LogWarning("Some Contacts were not added to ContactGroup upon initialization")
			}
		}
		self.init(id: id, name: name, contacts: returnedContacts, colorHex: colorHex, index: index)
	}
}
