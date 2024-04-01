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
	@Observable
	final class ViewModel {
		private(set) var isLoading = true
		private(set) var error: Error?

		@MainActor
		func initializeApp() async {
			defer { isLoading = false }
			isLoading = true
			error = nil

			do {
				@Dependency(\.contactsRepository) var contactsRepository
				@Dependency(\.groupsRepository) var groupsRepository
				/// `Contact`s **must** be fetched before `ContactGroup`s given the order of operations:
				/// 1) Contacts are fetched successfully
				///
				/// 2) `EmptyContactGroup` are fetched from `GroupsService` and converted to `ContactGroup`
				/// by iterating/updating `contactID` to `Contact` objects
				///
				/// 3) `(Empty)ContactGroup` is then merged/synced with fetched `Contact`s so that Contacts
				/// contact `groups: [EmptyContactGroup]` property
				///
				_ = try await contactsRepository.fetchContacts(refresh: true)
				let fetchedGroups = try await groupsRepository.fetchContactGroups(refresh: true)
				await contactsRepository.mergeAndSync(groups: fetchedGroups)
			} catch {
				LogError(error.localizedDescription)
				self.error = error
			}
		}
	}
}
