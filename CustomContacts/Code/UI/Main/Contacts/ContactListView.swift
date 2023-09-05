//
//  ContactListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct ContactListView: View {
	@StateObject var viewModel: ViewModel
	let onToggleTapped: () -> Void

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
			.navigationTitle(Localizable.Root.Contacts.title)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("🔄") {
						onToggleTapped()
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Menu("🔃") {
						// TODO: simplify with section for sort and order (First name/Last name/etc + ascending/descending)
						Button(Localizable.Contacts.Sort.firstNameAZ) {
							viewModel.setSortOption(to: .firstName(ascending: true))
						}
						Button(Localizable.Contacts.Sort.firstNameZA) {
							viewModel.setSortOption(to: .firstName(ascending: false))
						}
						Button(Localizable.Contacts.Sort.lastNameAZ) {
							viewModel.setSortOption(to: .lastName(ascending: true))
						}
						Button(Localizable.Contacts.Sort.lastNameZA) {
							viewModel.setSortOption(to: .lastName(ascending: false))
						}
					}
				}
			}
		}
	}
}
