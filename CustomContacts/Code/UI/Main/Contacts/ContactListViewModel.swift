//
//  ContactListViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsModels
import Dependencies
import Observation

extension ContactListView {
	@Observable final class ViewModel {
		@ObservationIgnored @Dependency(\.contactsRepository) private var contactsRepository
		private(set) var contacts: [Contact] = []
		private(set) var isLoading = false
		private(set) var error: Error?

		var searchText = ""
		private(set) var filterQueries: [FilterQuery] = []

		@MainActor func loadContacts(refresh: Bool = false) async {
			defer {
				isLoading = false
			}
			error = nil
			isLoading = true

			do {
				contacts = try await contactsRepository.getAllContacts(refresh)
			} catch {
				self.error = error
			}
		}
	}
}

extension ContactListView.ViewModel {
	func contactsSections() -> [(String, [Contact])] {
		/// Forces `contactsDisplayable` to update when `\.contacts` changes (?)
		access(keyPath: \.contacts)

		@Dependency(\.contactsProvider) var contactsProvider
		let contactsDisplayable = contactsProvider.filterContacts(filterQueries)
			.filter(searchText: searchText)

		var valueDictionary: [String: [Contact]] = [:]

		contactsDisplayable.forEach { contact in
			let letter = {
				switch Contact.SortOption.current.parameter {
				case .firstName:
					contact.firstName.first.map { String($0).uppercased() } ?? "-"
				case .lastName:
					contact.lastName.first.map { String($0).uppercased() } ?? "-"
				}
			}()
			valueDictionary[letter] = (valueDictionary[letter] ?? []) + [contact]
		}
		return valueDictionary
			.map { ($0.key, $0.value) }
			.sorted()
	}
}

extension ContactListView.ViewModel {
	func setSortOption(to parameter: Contact.SortOption.Parameter? = nil, ascending: Bool? = nil) {
		let updatedSortOption = Contact.SortOption(
			parameter: parameter ?? Contact.SortOption.current.parameter,
			ascending: ascending ?? Contact.SortOption.current.ascending
		)
		@Dependency(\.contactsProvider) var contactsProvider
		contacts = contactsProvider.sortContacts(updatedSortOption)
	}

	func addQuery(_ query: FilterQuery) {
		filterQueries.append(query)
	}

	func removeQuery(_ query: FilterQuery) {
		if let index = filterQueries.firstIndex(where: { $0.id == query.id }) {
			filterQueries.remove(at: index)
		}
	}

	func removeAllQueries() {
		filterQueries.removeAll()
	}
}
