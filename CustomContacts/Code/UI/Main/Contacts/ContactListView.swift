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
			ForEach(viewModel.contacts) { contact in
				NavigationLink(
					destination: {
						ContactDetailView(contact: contact)
					},
					label: { Text(contact.fullName) }
				)
			}
		}
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
		@Published private(set) var contacts: [Contact] = []
		@Published private(set) var error: Error?

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
