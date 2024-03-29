//
//  GroupCreationViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/27/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Observation
import SwiftUI

extension GroupCreationView {
	@Observable @MainActor
	final class ViewModel {
		var name = ""
		var color = Color.random
		var selectedContacts: Set<Contact> = []
		let onCompletion: () -> Void

		var displayableContacts: [Contact] {
			selectedContacts.sorted()
		}

		init(onCompletion: @escaping () -> Void) {
			self.onCompletion = onCompletion
		}
	}
}

extension GroupCreationView.ViewModel {
	/// Saves `ContactGroup` on main thread as this is a light data load
	/// and action is immediately related to user actions
	func createGroup() {
		Task(priority: .userInitiated) {
			do {
				@Dependency(\.groupsRepository) var groupsRepository
				let createdGroup = try await groupsRepository.createContactGroup(
					name: name,
					contacts: selectedContacts,
					colorHex: color.toHex ?? ""
				)
				LogInfo("Group created: \(createdGroup.name)")
				onCompletion()
			} catch {
				// TODO: error and loading states
				LogError("Group creation failed: \(error.localizedDescription)")
				print(error)
			}
		}
	}
}
