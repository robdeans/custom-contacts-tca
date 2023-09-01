//
//  ContactListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct ContactListView: View {
	@StateObject private var viewModel = ViewModel()
	let onToggleTapped: () -> Void

	var body: some View {
		NavigationStack {
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
				ToolbarItem(placement: .topBarLeading) {
					Button("🔄") {
						onToggleTapped()
					}
				}
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
}
