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
		List {
			ForEach(viewModel.contactsDisplayable) { contact in
				NavigationLink(
					destination: {
						ContactDetailView(contact: contact)
					},
					label: { Text(contact.fullName) }
				)
			}
		}
		.searchable(text: $viewModel.searchText)
		.refreshable {
			await viewModel.loadContacts(refresh: true)
		}
		.navigationTitle(Localizable.Root.Contacts.title)
	}
}

extension ContactListView {
	@MainActor
	private final class ViewModel: ObservableObject {
		@Dependency(\.contactsRepository) private var contactsRepository

		@Published private var contacts: [Contact] = []
		@Published var searchText = ""
		@Published private(set) var error: Error?

		var contactsDisplayable: [Contact] {
			if !searchText.isEmpty {
				return contacts.filter {
					// TODO: improve search filtering
					$0.fullName.lowercased().contains(searchText.lowercased())
				}
			}
			return contacts
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
	}
}
