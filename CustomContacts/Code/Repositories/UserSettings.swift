//
//  UserSettings.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/28/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies

// TODO: remove @unchecked, actually this entire implementation...
final class UserSettings: @unchecked Sendable {
	@Defaults(
		key: "contactsSortOption",
		defaultValue: Contact.SortOption(parameter: .lastName, ascending: true)
	)
	private(set) var contactsSortOption: Contact.SortOption

	func setSortOption(_ updatedSortOption: Contact.SortOption) {
		contactsSortOption = updatedSortOption
	}

	fileprivate init() {}
}

extension UserSettings: DependencyKey {
	static let liveValue = UserSettings()
	static var testValue: UserSettings {
		.liveValue
	}
}

extension DependencyValues {
	var userSettings: UserSettings {
		get { self[UserSettings.self] }
		set { self[UserSettings.self] = newValue }
	}
}
