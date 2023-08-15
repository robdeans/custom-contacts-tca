//
//  GroupDetailView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import Dependencies
import SwiftData
import SwiftUI

struct GroupDetailView: View {
	@Dependency(\.contactsRepository) private var contactsRepository
	@Bindable private(set) var group: ContactGroup

	@State private var isEditing = false
	private var color: Binding<Color> {
		Binding(
			get: { group.color },
			set: { group.colorHex = $0.toHex ?? "" }
		)
	}
	@State private var contactSelectorView: ContactSelectorView?

	var body: some View {
		VStack {
			Group {
				ColorPicker(
					selection: color,
					label: {
						// TODO: placeholder?
						TextField(group.name, text: $group.name)
							.foregroundStyle(group.color)
							.fontWeight(.semibold)
					}
				)
				.padding(Constants.UI.Padding.default)

				Button(Localizable.Groups.Edit.addRemove) {
					contactSelectorView = ContactSelectorView(selectedContactIDs: group.contactIDs) {
						// TODO: only save/persist when `Done` is tapped
						group.contactIDs = $0
					}
				}
			}
			.opacity(isEditing == true ? 1 : 0)

			List {
				ForEach(
					group.contactIDs
						.compactMap { contactsRepository.contact(for: $0) }
						.sorted(by: { $0.fullName < $1.fullName })
				) {
					Text($0.fullName)
				}
			}

			Spacer()
		}
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(
					isEditing
					? Localizable.Common.Actions.save
					: Localizable.Common.Actions.edit
				) {
					isEditing.toggle()
				}
			}
		}
		.navigationTitle(group.name)
		.sheet(item: $contactSelectorView) { $0 }
	}
}
