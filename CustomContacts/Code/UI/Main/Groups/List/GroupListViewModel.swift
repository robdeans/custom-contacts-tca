//
//  GroupListViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/1/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import Combine
import CustomContactsHelpers
import Dependencies
import Foundation

extension GroupListView {
	// TODO: why no @Observation work here?
	final class ViewModel: ObservableObject {
		@Dependency(\.groupsRepository) private var groupsRepository
		@Published private(set) var contactGroups: [ContactGroup] = []
		@Published private(set) var error: Error?
	}
}

extension GroupListView.ViewModel {
	@MainActor
	func fetchContactGroups(refresh: Bool = false) async {
		do {
			contactGroups = try await groupsRepository.fetchContactGroups(refresh: refresh)
			LogTrace("Fetched \(self.contactGroups.count) ContactGroup(s)")
		} catch {
			LogError("Error fetching groups: \(error.localizedDescription)")
			self.error = error
		}
	}

	@MainActor
	func updateContactGroupOrder(from origin: IndexSet, to destination: Int) async {
		do {
			try await groupsRepository.update(origin: origin, destination: destination)
		} catch {
			LogError("Error fetching groups: \(error.localizedDescription)")
			self.error = error
		}
	}
}
