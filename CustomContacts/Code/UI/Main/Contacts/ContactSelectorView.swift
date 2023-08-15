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
	@ObservedObject private var viewModel = ViewModel()

	var body: some View {
		List {
			ForEach(viewModel.contacts) {
				Text($0.fullName)
			}
		}
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
