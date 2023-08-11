//
//  GroupListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftData
import SwiftUI

struct GroupListView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: [SortDescriptor(\ContactGroup.name)])
	var groups: [ContactGroup]

	var body: some View {
		NavigationStack {
			List {
				ForEach(groups) { group in
					Text(group.name)
				}
			}
			.modelContainer(for: ContactGroup.self)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					NavigationLink(
						destination: {
							GroupEditorView()
								.modelContainer(for: ContactGroup.self)
							// Each NavigationLink requires new modelContainer?
						},
						label: { Text("Add Group") }
					)
				}
			}
		}
	}
}

struct GroupEditorView: View {
	@State private var name = ""
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 0) {
			TextField("Group Name", text: $name)
			Spacer()
			Button("Save") {
				let newGroup = ContactGroup(id: UUID().uuidString, name: name, contactIDs: [])
				modelContext.insert(newGroup)
				dismiss()
			}
		}
	}
}
