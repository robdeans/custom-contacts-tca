//
//  GroupsDataHandler.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Foundation
import SwiftData

/// @ModelActor that is responsible for interacting with CoreData/SwiftData via `modelContext`
@ModelActor
actor GroupsDataHandler {
	func fetchEmptyContactGroups() throws -> [EmptyContactGroup] {
		LogCurrentThread("🎎 GroupsDataHandler.fetchGroupIDs")
		return try modelContext.fetch(FetchDescriptor<ContactGroupData>())
			.map { EmptyContactGroup(contactGroupData: $0) }
	}

	@discardableResult
	func createGroup(
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) throws -> EmptyContactGroup {
		LogCurrentThread("🎎 GroupsDataHandler.createGroup")

		@Dependency(\.uuid) var uuid

		let newGroup = ContactGroupData(
			id: uuid().uuidString,
			name: name,
			contactIDs: contactIDs,
			colorHex: colorHex
		)
		modelContext.insert(newGroup)
		try modelContext.save()
		return EmptyContactGroup(contactGroupData: newGroup)
	}

	@discardableResult
	func updateGroup(
		id: EmptyContactGroup.ID,
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) throws -> EmptyContactGroup {
		LogCurrentThread("🎎 GroupsDataHandler.updateGroup")

		let updatedGroup = ContactGroupData(
			id: id,
			name: name,
			contactIDs: contactIDs,
			colorHex: colorHex
		)
		try modelContext.delete(
			model: ContactGroupData.self,
			where: #Predicate {
				$0.id == id
			}
		)
		modelContext.insert(updatedGroup)
		try modelContext.save()
		return EmptyContactGroup(contactGroupData: updatedGroup)
	}
}
