//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftData

@Model
final class ContactGroupData {
	let id: ContactGroupData.ID
	let name: String
	let contactIDs: Set<Contact.ID>
	let colorHex: String
	let index: Int

	init(
		id: ContactGroupData.ID,
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String,
		index: Int
	) {
		self.id = id
		self.name = name
		self.contactIDs = contactIDs
		self.colorHex = colorHex
		self.index = index
	}
}

extension ContactGroupData {
	public typealias ID = String
}
