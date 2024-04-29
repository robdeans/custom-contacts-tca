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
				_ = try await contactsRepository.fetchContacts(refresh: true)
			} catch {
				LogError(error.localizedDescription)
				self.error = error
			}
		}
	}
}
