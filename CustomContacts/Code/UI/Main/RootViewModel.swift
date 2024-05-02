//
//  RootViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import Dependencies
import Observation

extension RootView {
	@Observable @MainActor
	final class ViewModel {
		@ObservationIgnored @Dependency(\.contactsRepository) private var contactsRepository
		@ObservationIgnored @Dependency(\.groupsRepository) private var groupsRepository
		private(set) var isLoading = false
		private(set) var error: Error?

		func initializeApp() async {
			defer { isLoading = false }
			isLoading = true
			error = nil

			do {
				let syncContactsAndGroupsTask = Task(priority: .background) {
					/// Contacts must first be fetched and assigned to respective properties
					/// so that when `ContactGroup` is fetched, `Contact` can be injected using `getContact(id:)`
					_ = try await contactsRepository.fetchContacts(refresh: true)

					let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: true)

					await contactsRepository.syncContacts(with: fetchedGroups)
				}
				try await syncContactsAndGroupsTask.value
			} catch {
				LogError(error.localizedDescription)
				self.error = error
			}
		}
	}
}
