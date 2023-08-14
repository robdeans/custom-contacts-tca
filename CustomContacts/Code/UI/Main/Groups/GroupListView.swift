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

	@State private var createGroupView: GroupEditorView?
	@State private var groupDetailView: GroupEditorView?

	var body: some View {
		ZStack {
			List {
				ForEach(groups) { group in
					NavigationLink(
						destination: { GroupDetailView(group: group) },
						label: { Text(group.name) }
					)
				}
			}

			createGroupButton
		}
		.sheet(item: $createGroupView) { $0 }
		.modelContainer(for: ContactGroup.self)
	}

	private var createGroupButton: some View {
		Button(
			action: { createGroupView = GroupEditorView() },
			label: {
				Text("+")
					.frame(width: 55, height: 55)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius()
			}
		)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
		.padding(Constants.UI.Padding.default)
	}
}
