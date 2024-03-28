//
//  GroupCreationView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import SwiftUI

private enum Layout {
	static let bottomViewHeight = CGFloat(40)
}

@MainActor
struct GroupCreationView: View {
	@Dependency(\.contactsRepository) private var contactsRepository

	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	@State private var name = ""
	@State private var color = Color.random
	@State private(set) var selectedContactIDs = Set<Contact.ID>()

	@State private var contactSelectorView: ContactSelectorView?

	@State private var showError = false

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Group {
					ColorPicker(
						selection: $color,
						supportsOpacity: true,
						label: {
							TextField(Localizable.Groups.Edit.groupName, text: $name)
								.autocorrectionDisabled()
								.foregroundStyle(color)
								.fontWeight(.semibold)
						}
					)
					.padding(.vertical, Constants.UI.Padding.default)

					Button(Localizable.Groups.Edit.addRemove) {
						contactSelectorView = ContactSelectorView(selectedContactIDs: selectedContactIDs) {
							selectedContactIDs = $0
						}
					}
				}
				.padding(Constants.UI.Padding.default)

				List {
					ForEach(
						selectedContactIDs
							.compactMap { contactsRepository.getContact($0) }
							.sorted(by: { $0.displayName < $1.displayName })
					) {
						Text($0.displayName)
					}
				}

				Spacer()
			}

			HStack {
				Button(
					action: { dismiss() },
					label: {
						Text(Localizable.Common.Actions.cancel)
							.frame(maxWidth: .infinity)
					}
				)

				Button(
					action: createGroup,
					label: {
						Text(Localizable.Common.Actions.save)
							.frame(maxWidth: .infinity)
					}
				)
			}
			.frame(height: Layout.bottomViewHeight)
			.frame(maxHeight: .infinity, alignment: .bottom)
		}
		.sheet(item: $contactSelectorView) { $0 }
	}

	/// Saves `ContactGroup` on main thread as this is a light data load
	/// and action is immediately related to user actions
	private func createGroup() {
		Task(priority: .userInitiated) {
			PrintCurrentThread("createGroup")
			do {
				let container = modelContext.container
				let handler = ContactGroupHandler(modelContainer: container)

				let groupID = try await handler.createGroup(
					name: name,
					contactIDs: selectedContactIDs,
					colorHex: color.toHex ?? ""
				)
				LogInfo("Group created: \(groupID)")
				dismiss()
			} catch {
				LogError("Group creation failed: \(error.localizedDescription)")
				showError = true
			}
		}
	}
}

extension GroupCreationView: Identifiable {
	nonisolated var id: String {
		// TODO: is this the best way to determine ID?
		"GroupCreationView"
	}
}
