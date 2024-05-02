//
//  GroupsDataService+Mock.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Foundation
import SwiftData

extension GroupsDataService {
	public static var testValue: GroupsDataService {
		Self(
			fetchContactGroups: {
				EmptyContactGroup.mockArray
			},
			createContactGroup: { name, contactIDs, colorHex, index in
				EmptyContactGroup(
					id: "test-id",
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex,
					index: index
				)
			},
			updateContactGroup: { id, name, contactIDs, colorHex, index in
				EmptyContactGroup(
					id: id,
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex,
					index: index
				)
			}
		)
	}
	public static let previewValue: GroupsDataService = .testValue
}
