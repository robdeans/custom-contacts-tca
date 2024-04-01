//
//  GroupDetailViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/1/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Observation

extension GroupDetailView {
	@Observable
	final class ViewModel {
		private let group: ContactGroup
		private(set) var isLoading = false
		private(set) var error: Error?

		init(group: ContactGroup) {
			self.group = group
		}
	}
}

extension GroupDetailView.ViewModel {
	@MainActor
	func updateGroup(
		name: String,
		contacts: [Contact],
		colorHex: String
	) async {
		defer { isLoading = false }
		isLoading = true
		do {
			@Dependency(\.groupsRepository) var groupsRepository
			try await groupsRepository.updateContactGroup(
				id: group.id,
				name: name,
				contactIDs: Set(contacts.map { $0.id }),
				colorHex: colorHex
			)
		} catch {
			LogError("Unable to update ContactGroup: \(error.localizedDescription)")
			self.error = error
		}
	}
}
