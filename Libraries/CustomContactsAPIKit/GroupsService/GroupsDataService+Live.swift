//
//  GroupsDataService+Live.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/28/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Foundation
import SwiftData

extension GroupsDataService: DependencyKey {
	public static var liveValue: GroupsDataService {
		// TODO: is this the safest way to obtain a modelContainer? Seems necessary to keep data in sync
		let modelContainer = try! ModelContainer(for: ContactGroupData.self)
		let contactGroupHandler = ContactGroupHandler(modelContainer: modelContainer)

		return Self(
			fetchContactGroups: {
				LogCurrentThread("🧑‍🧑‍🧒‍🧒 GroupsDataService.fetchContactGroups")
				return try await contactGroupHandler.fetchEmptyContactGroups()
			},
			createContactGroup: { name, contactIDs, colorHex in
				let createdContactGroup = try await contactGroupHandler.createGroup(
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex
				)
				return createdContactGroup
			}
		)
	}
}

extension GroupsDataService {
	enum DataError: Error {
		case noDataFound(id: PersistentIdentifier)
	}
	private static func emptyContactGroup(
		for objectID: PersistentIdentifier,
		in modelContainer: ModelContainer
	) throws -> EmptyContactGroup {
		let modelContext = ModelContext(modelContainer)
		guard let data = try modelContext.existingModel(for: objectID) as ContactGroupData? else {
			throw DataError.noDataFound(id: objectID)
		}

		return EmptyContactGroup(contactGroupData: data)
	}
}
