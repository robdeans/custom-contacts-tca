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
	@ObservedObject private var viewModel = ViewModel()

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
		.navigationTitle(Localizable.Root.Contacts.title)
	}
}

extension ContactListView {
	@MainActor
	private final class ViewModel: ObservableObject {
		@Published private(set) var contacts: [Contact] = []

		init() {
			Task {
				do {
					guard try await ContactsService.liveValue.requestContactsPermissions() else {
						// Permissions denied state
						return
					}
					contacts = try await ContactsService.liveValue.fetchContacts()
				} catch {
					//show error
				}
			}
		}
	}
}
