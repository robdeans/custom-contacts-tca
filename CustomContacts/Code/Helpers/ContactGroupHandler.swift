//
//  ContactGroupHandler.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/26/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import SwiftData

@ModelActor
actor ContactGroupHandler {
	@discardableResult
	func createGroup(
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) throws -> PersistentIdentifier {
		PrintCurrentThread("ContactGroupHandler")

		@Dependency(\.uuid) var uuid

		let newGroup = ContactGroup(
			id: uuid().uuidString,
			name: name,
			contactIDs: contactIDs,
			colorHex: colorHex
		)
		modelContext.insert(newGroup)
		try modelContext.save()
		return newGroup.persistentModelID
	}
}
