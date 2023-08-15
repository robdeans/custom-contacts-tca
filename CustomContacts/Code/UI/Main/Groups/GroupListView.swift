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

	@State private var createGroupView: GroupCreationView?
	@State private var groupDetailView: GroupDetailView?

	var body: some View {
		ZStack {
			List {
				ForEach(groups) { group in
					GroupCardView(group: group) {
						groupDetailView = GroupDetailView(group: group)
					}
				}
			}

			createGroupButton
		}
		.navigationTitle(Localizable.Root.Groups.title)
		.sheet(item: $createGroupView) { $0 }
		.navigationDestination(to: $groupDetailView) { $0 }
		.modelContainer(for: ContactGroup.self)
	}

	private var createGroupButton: some View {
		Button(
			action: { createGroupView = GroupCreationView() },
			label: {
				Text("+")
					.frame(width: 55, height: 55)
					.background(Color.blue)
					.foregroundStyle(.white)
					.cornerRadius()
			}
		)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
		.padding(Constants.UI.Padding.default)
	}
}
