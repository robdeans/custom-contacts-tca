//
//  Contact.SortOption+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 1/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies

extension Contact.SortOption {
	static var current: Contact.SortOption {
		@Dependency(\.userSettings) var userSettings
		return userSettings.contactsSortOption
	}
}
