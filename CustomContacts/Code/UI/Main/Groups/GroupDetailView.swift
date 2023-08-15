//
//  GroupDetailView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftData
import SwiftUI

struct GroupDetailView: View {
	@Bindable private(set) var group: ContactGroup

	@State private var isEditing = false
	@State private var contactSelectorView: ContactSelectorView?

	var body: some View {
		VStack {
			Button(Localizable.Groups.Edit.addRemove) {
				contactSelectorView = ContactSelectorView(selectedContactIDs: group.contactIDs) {
					// TODO: only save/persist when `Done` is tapped
					group.contactIDs = $0
				}
			}
			.opacity(isEditing == true ? 1 : 0)

			List {
				ForEach(Array(group.contactIDs.sorted()), id: \.hashValue) {
					Text($0)
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
