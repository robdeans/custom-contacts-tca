//
//  ContactSelectorView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies
import Observation
import SwiftUI

struct ContactSelectorView: View {
	@State private var viewModel = ViewModel()
	@Environment(\.dismiss) private var dismiss

	@State private var editMode = EditMode.active
	@State private var selectedContacts: Set<Contact>

	private let onDoneTapped: (Set<Contact>) -> Void

	init(
		selectedContacts: Set<Contact>,
		onDoneTapped: @escaping (Set<Contact>) -> Void
	) {
		self.onDoneTapped = onDoneTapped
		_selectedContacts = State(initialValue: Set(selectedContacts))
	}

	var body: some View {
		NavigationStack {
			List(viewModel.contactsDisplayable, id: \.self, selection: $selectedContacts) {
				ContactCardView(contact: $0)
			}
			.searchable(text: $viewModel.searchText)
			.refreshable {
				await viewModel.loadContacts(refresh: true)
			}
			.environment(\.editMode, $editMode)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button(Localizable.Common.Actions.cancel) {
						dismiss()
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(Localizable.Common.Actions.done) {
						onDoneTapped(selectedContacts)
						dismiss()
					}
				}
			}
		}
		.task {
			await viewModel.loadContacts()
		}
	}
}

extension ContactSelectorView: Identifiable {
	var id: String {
		@Dependency(\.uuid) var uuid
		return uuid().uuidString
	}
}

extension ContactSelectorView {
	// Could be `private` if not for Xcode warnings re: @Observable
	@Observable final class ViewModel {
		private var contacts: [Contact] = []
		var searchText = ""
		private(set) var error: Error?

		var contactsDisplayable: [Contact] {
			contacts.filter(searchText: searchText)
		}

		@MainActor func loadContacts(refresh: Bool = false) async {
			do {
				@Dependency(\.contactsRepository) var contactsRepository
				contacts = try await contactsRepository.fetchContacts(refresh: refresh)
			} catch {
				self.error = error
			}
		}
	}
}
