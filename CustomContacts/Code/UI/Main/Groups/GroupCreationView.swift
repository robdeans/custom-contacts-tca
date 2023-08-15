//
//  GroupCreationView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

private enum Layout {
	static let bottomViewHeight = CGFloat(40)
}

struct GroupCreationView: View {
	@State private var name = ""
	@State private(set) var selectedContactIDs = Set<Contact.ID>()
	@State private var contactSelectorView: ContactSelectorView?

	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				TextField("Group Name", text: $name)
					.padding(Constants.UI.Padding.default)

				Button(Localizable.Groups.Edit.addRemove) {
					contactSelectorView = ContactSelectorView(selectedContactIDs: selectedContactIDs) {
						selectedContactIDs = $0
					}
				}

				List {
					ForEach(Array(selectedContactIDs.sorted()), id: \.hashValue) {
						Text($0)
					}
				}

				Spacer()
			}

			HStack {
				Button(
					action: { dismiss() },
					label: {
						Text("Cancel")
							.frame(maxWidth: .infinity)
					}
				)

				Button(
					action: {
						let newGroup = ContactGroup.create(id: id, name: name, contactIDs: selectedContactIDs)
						modelContext.insert(newGroup)
						dismiss()
					},
					label: {
						Text("Save")
							.frame(maxWidth: .infinity)
					}
				)
			}
			.frame(height: Layout.bottomViewHeight)
			.frame(maxHeight: .infinity, alignment: .bottom)
		}
		.sheet(item: $contactSelectorView) { $0 }
	}
}

extension GroupCreationView: Identifiable {
	var id: String {
		UUID().uuidString
	}
}
