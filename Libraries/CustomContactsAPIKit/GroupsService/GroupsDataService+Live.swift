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

extension GroupsDataService {
	public static var liveValue: GroupsDataService {
		// TODO: is this the safest way to obtain a modelContainer? Seems necessary to keep data in sync
		let modelContainer = try! ModelContainer(for: ContactGroupData.self)
		let groupsDataHandler = GroupsDataHandler(modelContainer: modelContainer)

		return Self(
			fetchContactGroups: {
				LogCurrentThread("🎎 GroupsDataService.fetchContactGroups")
				return try await groupsDataHandler.fetchEmptyContactGroups()
			},
			createContactGroup: { name, contactIDs, colorHex, index in
				let createdContactGroup = try await groupsDataHandler.createGroup(
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex,
					index: index
				)
				return createdContactGroup
			},
			updateContactGroup: { id, name, contactIDs, colorHex, index in
				let createdContactGroup = try await groupsDataHandler.updateGroup(
					id: id,
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex,
					index: index
				)
				return createdContactGroup
			}
		)
	}
}
