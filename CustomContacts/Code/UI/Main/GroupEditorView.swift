//
//  GroupEditorView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

struct GroupEditorView: View {
	@State private var name = ""
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 0) {
			TextField("Group Name", text: $name)
			Spacer()
			Button("Save") {
				let newGroup = ContactGroup.create(name: name)
				modelContext.insert(newGroup)
				dismiss()
			}
		}
	}
}
