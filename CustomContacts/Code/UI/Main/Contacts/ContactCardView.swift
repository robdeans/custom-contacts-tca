//
//  ContactCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftData
import SwiftUI

private enum Layout {
	static let indicatorSize: CGFloat = 10.0
}

struct ContactCardView: View {
	@Bindable private var viewModel: ViewModel

	init(contact: Contact) {
		_viewModel = Bindable(ViewModel(contact: contact))
	}

	var body: some View {
		HStack {
			Text(viewModel.contact.displayName)
			self.contactGroupIndicatorView
			Spacer()
		}
		.task {
			await viewModel.getGroups()
		}
	}

	private var contactGroupIndicatorView: some View {
		let filteredGroups = viewModel.groups.filter { $0.contactIDs.contains(viewModel.contact.id) }

		return ZStack(alignment: .leading) {
			ForEach(Array(filteredGroups.enumerated()), id: \.element.id) { index, group in
				Circle()
					.fill(group.color)
					.frame(width: Layout.indicatorSize, height: Layout.indicatorSize)
					.padding(.leading, (Layout.indicatorSize / 1.4) * CGFloat(index))
			}
		}
	}
}

import CustomContactsHelpers
import Dependencies

extension ContactCardView {
	@Observable
	final class ViewModel {
		let contact: Contact
		private(set) var groups: [ContactGroup] = []

		init(contact: Contact) {
			self.contact = contact
		}

		// TODO: this seems excessive... maybe iterate through each ContactGroup and inject the Contacts?
		@MainActor
		func getGroups() async {
			do {
				@Dependency(\.groupsRepository) var groupsRepository
				groups = try await groupsRepository.fetchContactGroups(refresh: false)
			} catch {
				LogError("Unable to load contacts for ContactsCards")
			}
		}
	}
}
