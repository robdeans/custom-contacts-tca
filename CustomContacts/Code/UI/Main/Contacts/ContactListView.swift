//
//  ContactListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

struct ContactListView: View {
	@StateObject private var contactListNavigation = ContactListNavigation()
	@Bindable var viewModel: ViewModel

	var body: some View {
		NavigationStack(path: $contactListNavigation.path) {
			VStack {
				FilterView(
					filterQueries: viewModel.filterQueries,
					onAddQueryTapped: { viewModel.addQuery($0) },
					onRemoveQueryTapped: { viewModel.removeQuery($0) },
					onClearTapped: { viewModel.removeAllQueries() }
				)
				List {
					ForEach(viewModel.contactsDisplayable) { contact in
						ContactCardView(contact: contact)
							.contentShape(Rectangle())
							.onTapGesture {
								contactListNavigation.path.append(.contactDetail(contact))
							}
					}
				}
				.searchable(text: $viewModel.searchText)
				.refreshable {
					await viewModel.loadContacts(refresh: true)
				}
			}
			.navigationDestination(for: contactListNavigation)
			.navigationTitle(Localizable.Root.Contacts.title)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Menu("🔃") {
						ForEach(Contact.SortOption.Parameter.allCases, id: \.rawValue) { parameter in
							Button(parameter.title) {
								viewModel.setSortOption(to: parameter)
							}
						}
						Divider()
						sortOrderButton(ascending: true)
						sortOrderButton(ascending: false)
					}
				}
			}
		}
		.environmentObject(contactListNavigation)
	}

	private func sortOrderButton(ascending: Bool) -> some View {
		let title = ascending ? Localizable.Contacts.Sort.ascending
		: Localizable.Contacts.Sort.descending
		let checkmark = Contact.SortOption.current.ascending == ascending ? " ✓" : ""
		return Button(title + checkmark) {
			viewModel.setSortOption(ascending: ascending)
		}
	}
}

extension Contact.SortOption.Parameter {
	var title: String {
		let checkmark = Contact.SortOption.current.parameter == self ? " ✓" : ""
		switch self {
		case .firstName:
			return Localizable.Contacts.Sort.firstName + checkmark
		case .lastName:
			return Localizable.Contacts.Sort.lastName + checkmark
		}
	}
}
