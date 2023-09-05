//
//  ContactListViewModel.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsAPIKit
import Dependencies

extension ContactListView {
	final class ViewModel: ObservableObject {
		@Dependency(\.contactsRepository) private var contactsRepository
		@Published private var contacts: [Contact] = []
		@Published private(set) var error: Error?

		@Published var searchText = ""
		@Published private(set) var filterQueries: [FilterQuery] = [] {
			didSet {
				cancellables = filterQueries.map {
					$0.objectWillChange.sink { [weak self] in
						self?.objectWillChange.send()
					}
				}
			}
		}

		private var cancellables = [AnyCancellable]()

		init() {
			Task {
				await loadContacts(refresh: true)
			}
		}

		@MainActor func loadContacts(refresh: Bool = false) async {
			do {
				contacts = try await contactsRepository.getContacts(refresh: refresh)
			} catch {
				self.error = error
			}
		}
	}
}

// TODO: add test coverage
extension ContactListView.ViewModel {
	func setSortOption(to parameter: Contact.SortOption.Parameter? = nil, ascending: Bool? = nil) {
		let updatedSortOption = Contact.SortOption(
			parameter: parameter ?? Contact.SortOption.current.parameter,
			ascending: ascending ?? Contact.SortOption.current.ascending
		)
		contacts = contactsRepository.sortContacts(by: updatedSortOption)
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

	func contactsDisplayable() -> [Contact] {
		var filteredContactIDs = Set<Contact.ID>()
		if !filterQueries.isEmpty {
			filterQueries.forEach {
				switch $0.operator {
				case .and:
					switch $0.filter {
					case .include:
						filteredContactIDs.formIntersection($0.group.contactIDs)
					case .exclude:
						var allContactIDsExcludingGroup = contactsRepository.contactIDs
						$0.group.contactIDs.forEach {
							filteredContactIDs.remove($0)
							allContactIDsExcludingGroup.remove($0)
						}
						filteredContactIDs.formUnion(allContactIDsExcludingGroup)
					}
				case .or:
					switch $0.filter {
					case .include:
						filteredContactIDs.formUnion($0.group.contactIDs)
					case .exclude:
						var allContactIDsExcludingGroup = contactsRepository.contactIDs
						$0.group.contactIDs.forEach {
							allContactIDsExcludingGroup.remove($0)
						}
						filteredContactIDs.formUnion(allContactIDsExcludingGroup)
					}
				}
			}
		} else {
			filteredContactIDs = contactsRepository.contactIDs
		}

		return filteredContactIDs
			.compactMap(contactsRepository.contact)
			.filter { contact in
				guard !searchText.isEmpty else {
					return true
				}
				return contact.fullName.lowercased().contains(searchText.lowercased())
			}
			.sorted()
	}
}
