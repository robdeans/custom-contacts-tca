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
			createContactGroup: { _, _, _, _ in
				EmptyContactGroup.mock
			},
			updateContactGroup: { _, _, _, _, _ in
				EmptyContactGroup.mock
			}
		)
	}
	public static let previewValue: GroupsDataService = .testValue
}
