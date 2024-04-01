//
//  GroupDetailView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import Dependencies
import SwiftData
import SwiftUI

@MainActor
struct GroupDetailView: View {
	@Environment(\.dismiss) private var dismiss
	@Bindable private var viewModel: ViewModel
	@State private var contactSelectorView: ContactSelectorView?

	@State private var isEditing = false
	@State private var color: Color
	@State private var name: String
	@State private var contacts: [Contact]

	init(group: ContactGroup) {
		_viewModel = Bindable(ViewModel(group: group))
		color = group.color
		name = group.name
		contacts = group.contacts
	}

	var body: some View {
		ZStack {
			contentView
			addRemoveContactsButton
		}
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(
					isEditing
					? Localizable.Common.Actions.save
					: Localizable.Common.Actions.edit
				) {
					if isEditing {
						Task {
							await viewModel.updateGroup(
								name: name,
								contacts: contacts,
								colorHex: color.toHex ?? ""
							)
							isEditing = false
						}
					} else {
						withAnimation {
							isEditing = true
						}
					}
				}
				.padding(Constants.UI.Padding.small)
				.background(Color.white.opacity(0.2))
				.cornerRadius(15)
			}
		}
		.toolbarBackground(color, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar)
		.navigationTitle(name)
		.sheet(item: $contactSelectorView) { $0 }
	}

	private var contentView: some View {
		VStack {
			if isEditing {
				ColorPicker(
					selection: $color,
					label: {
						TextField(name, text: $name)
							.foregroundStyle(color)
							.fontWeight(.semibold)
					}
				)
				.padding(Constants.UI.Padding.default)
			}

			List {
				ForEach(contacts.sorted()) {
					Text($0.displayName)
				}
			}
			.padding(.top, Constants.UI.Padding.default)

			Spacer()
		}
		.ignoresSafeArea(edges: [.bottom])
	}

	private var addRemoveContactsButton: some View {
		Button(
			action: {
				contactSelectorView = ContactSelectorView(selectedContacts: Set(contacts)) {
					contacts = Array($0)
				}
			},
			label: {
				Text(Localizable.Groups.Edit.addRemove)
					.fontWeight(.semibold)
					.foregroundStyle(Color.white)
					.padding()
					.background(color)
					.cornerRadius()
			}
		)
		.frame(maxHeight: .infinity, alignment: .bottom)
		.padding(.bottom, Constants.UI.Padding.default)
		.opacity(isEditing ? 1 : 0)
	}
}

#Preview {
	return NavigationStack {
		GroupDetailView(
			group: .mock
		)
	}
}
