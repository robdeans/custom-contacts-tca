//
//  ContactListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import Dependencies
import SwiftUI

struct ContactListView: View {
	@StateObject private var viewModel = ViewModel()

	var body: some View {
		VStack {
			FilterView(
				filterQueries: viewModel.filterQueries,
				onAddQueryTapped: { viewModel.addQuery($0) },
				onRemoveQueryTapped: { viewModel.removeQuery($0) },
				onClearTapped: { viewModel.removeAllQueries() }
			)

			List {
				ForEach(viewModel.contactsDisplayable()) { contact in
					NavigationLink(
						destination: {
							ContactDetailView(contact: contact)
						},
						label: {
							ContactCardView(contact: contact)
						}
					)
				}
			}
			.searchable(text: $viewModel.searchText)
			.refreshable {
				await viewModel.loadContacts(refresh: true)
			}
		}
		.navigationTitle(Localizable.Root.Contacts.title)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu("🔃") {
					Button("First name A↔Z") {
						viewModel.setSortOption(to: .firstName(ascending: true))
					}
					Button("First name Z↔A") {
						viewModel.setSortOption(to: .firstName(ascending: false))
					}
					Button("Last name A↔Z") {
						viewModel.setSortOption(to: .lastName(ascending: true))
					}
					Button("Last name Z↔A") {
						viewModel.setSortOption(to: .lastName(ascending: false))
					}
				}
			}
		}
	}
}

import Combine
extension ContactListView {
	@MainActor
	private final class ViewModel: ObservableObject {
		@Dependency(\.contactsRepository) private var contactsRepository
		@Published private var contacts: [Contact] = []
		@Published private(set) var error: Error?

		@Published var searchText = ""
		@Published private(set) var filterQueries: [FilterQuery] = [] {
			didSet {
				trackQueryChanges()
			}
		}

		private var cancellables = [AnyCancellable]()
		private func trackQueryChanges() {
			cancellables = filterQueries.map {
				$0.objectWillChange.sink { [weak self] in
					self?.objectWillChange.send()
				}
			}
		}

		func contactsDisplayable() -> [Contact] {
			var filteredContactIDs = Set<Contact.ID>()
			if !filterQueries.isEmpty {
				filterQueries.forEach {
					// handle nil group better?
					guard let group = $0.group else {
						return
					}
					switch $0.andOr {
					case .and:
						switch $0.relation {
						case .included:
							filteredContactIDs.formIntersection(group.contactIDs)
						case .excluded:
							var allContactIDsExcludingGroup = contactsRepository.contactIDs
							group.contactIDs.forEach {
								filteredContactIDs.remove($0)
								allContactIDsExcludingGroup.remove($0)
							}
							filteredContactIDs.formUnion(allContactIDsExcludingGroup)
						}
					case .or:
						switch $0.relation {
						case .included:
							filteredContactIDs.formUnion(group.contactIDs)
						case .excluded:
							var allContactIDsExcludingGroup = contactsRepository.contactIDs
							group.contactIDs.forEach {
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

		init() {
			Task {
				await loadContacts(refresh: true)
			}
		}

		func loadContacts(refresh: Bool = false) async {
			do {
				contacts = try await contactsRepository.getContacts(refresh: refresh)
			} catch {
				self.error = error
			}
		}

		func setSortOption(to sortOption: Contact.SortOption) {
			contacts = contactsRepository.sortContacts(by: sortOption)
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
}
