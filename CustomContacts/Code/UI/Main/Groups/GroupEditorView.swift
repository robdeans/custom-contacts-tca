//
//  GroupEditorView.swift
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

struct GroupEditorView: View {
	@State private var name = ""
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				TextField("Group Name", text: $name)
					.padding(Constants.UI.Padding.default)

				ContactSelectorView()
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
						let newGroup = ContactGroup.create(id: id, name: name)
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
	}
}

extension GroupEditorView: Identifiable {
	var id: String {
		UUID().uuidString
	}
}
