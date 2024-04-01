//
//  ContactGroupHandler.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import SwiftData

/// @ModelActor that is responsible for interacting with CoreData/SwiftData via `modelContext`
@ModelActor
actor ContactGroupHandler {
	func fetchGroupIDs() throws -> [PersistentIdentifier] {
		LogCurrentThread("🧑‍🧑‍🧒‍🧒 ContactGroupHandler.fetchGroupIDs")
		let groups = try modelContext.fetch(FetchDescriptor<ContactGroupData>())
		return groups.map { $0.persistentModelID }
	}

	@discardableResult
	func createGroup(
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) throws -> PersistentIdentifier {
		LogCurrentThread("🧑‍🧑‍🧒‍🧒 ContactGroupHandler.createGroup")

		@Dependency(\.uuid) var uuid

		let newGroup = ContactGroupData(
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
