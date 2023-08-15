//
//  ContactSelectorView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

struct ContactSelectorView: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject private var viewModel = ViewModel()

	@State private var editMode = EditMode.active
	@State private var selectedContactIDs: Set<Contact.ID>

	private let onDoneTapped: (Set<Contact.ID>) -> Void

	init(
		selectedContactIDs: Set<Contact.ID>,
		onDoneTapped: @escaping (Set<Contact.ID>) -> Void
	) {
		self.onDoneTapped = onDoneTapped
		_selectedContactIDs = State(initialValue: selectedContactIDs)
	}

	var body: some View {
		NavigationStack {
			List(viewModel.contacts, selection: $selectedContactIDs) {
				Text($0.fullName)
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button(Localizable.Common.Actions.cancel) {
						dismiss()
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(Localizable.Common.Actions.done) {
						onDoneTapped(selectedContactIDs)
						dismiss()
					}
				}
			}
			.environment(\.editMode, $editMode)
		}
	}
}

extension ContactSelectorView: Identifiable {
	var id: String {
		UUID().uuidString
	}
}

extension ContactSelectorView {
	@MainActor
	private final class ViewModel: ObservableObject {
		@Published private(set) var contacts: [Contact] = []

		init() {
			// TODO: this feels redundant. Can Contacts be stored in an @Environment repository?
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
