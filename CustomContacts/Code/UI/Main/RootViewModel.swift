//
//  RootViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import Dependencies
import Observation

extension RootView {
	@Observable
	final class ViewModel {
		private(set) var isLoading = true

		@MainActor
		func initializeApp() async {
			defer { isLoading = false }
			@Dependency(\.contactsRepository) var contactsRepository
			@Dependency(\.groupsRepository) var groupsRepository

			isLoading = true
			do {
				_ = try await contactsRepository.fetchContacts(refresh: true)
				let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: true)
				await contactsRepository.mergeAndSync(groups: fetchedGroups)
			} catch {
				print(error)
			}
		}
	}
}
