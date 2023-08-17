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
		ZStack {
			VStack {
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
				.opacity(isEditing == true ? 1 : 0)

				List {
					ForEach(
						group.contactIDs
							.compactMap { contactsRepository.contact(for: $0) }
							.sorted()
					) {
						Text($0.fullName)
					}
				}

				Spacer()
			}
			.ignoresSafeArea(edges: [.bottom])

			if isEditing {
				Button(
					action: {
						contactSelectorView = ContactSelectorView(selectedContactIDs: group.contactIDs) {
							// TODO: only save/persist when `Done` is tapped
							group.contactIDs = $0
						}
					},
					label: {
						Text(Localizable.Groups.Edit.addRemove)
							.fontWeight(.semibold)
							.foregroundStyle(Color.white)
							.padding()
							.background(group.color)
							.cornerRadius()
					}
				)
				.frame(maxHeight: .infinity, alignment: .bottom)
				.padding(Constants.UI.Padding.default)
			}
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
		.toolbarBackground(group.color, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar)
		.navigationTitle(group.name)
		.sheet(item: $contactSelectorView) { $0 }
		.ignoresSafeArea(edges: [.bottom])
	}
}

#Preview {
	MainActor.assumeIsolated {
		let container = previewContainer
		return GroupDetailView(
			group: .mock
		)
			.modelContainer(container)
	}
}

@MainActor
private let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(for: ContactGroup.self, ModelConfiguration(inMemory: true))
		container.mainContext.insert(ContactGroup.mock)
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
