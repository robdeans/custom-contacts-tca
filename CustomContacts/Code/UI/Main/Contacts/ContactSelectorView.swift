//
//  ContactSelectorView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import Dependencies
import SwiftUI

struct ContactSelectorView: View {
	@Dependency(\.uuid) private var uuid
	@StateObject private var viewModel = ViewModel()
	@Environment(\.dismiss) private var dismiss

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
			.refreshable {
				await viewModel.loadContacts(refresh: true)
			}
		}
	}
}

extension ContactSelectorView: Identifiable {
	var id: String {
		uuid().uuidString
	}
}

extension ContactSelectorView {
	private final class ViewModel: ObservableObject {
		@Dependency(\.contactsRepository) private var contactsRepository
		@Published private(set) var contacts: [Contact] = []
		@Published private(set) var error: Error?

		init() {
			Task {
				// Contacts should already have loaded on earlier screen
				await loadContacts()
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
