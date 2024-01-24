//
//  GroupListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftData
import SwiftUI

struct GroupListView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: [SortDescriptor(\ContactGroup.name)])
	var groups: [ContactGroup]

	@StateObject private var groupListNavigation = GroupListNavigation()

	@State private var createGroupView: GroupCreationView?

	var body: some View {
		NavigationStack(path: $groupListNavigation.path) {
			ZStack {
				List {
					ForEach(groups) { group in
						GroupCardView(group: group) {
							groupListNavigation.path.append(.groupDetail(group))
						}
					}
				}

				createGroupButton
			}
			.navigationTitle(Localizable.Root.Groups.title)
			.sheet(item: $createGroupView) { $0 }
			.navigationDestination(for: groupListNavigation)
		}
		.modelContainer(for: ContactGroup.self)
		.environmentObject(groupListNavigation)
	}

	private var createGroupButton: some View {
		Button(
			action: { createGroupView = GroupCreationView() },
			label: {
				Text("+")
					.fontWeight(.heavy)
					.frame(width: 55, height: 55)
					.background(Color.blue)
					.foregroundStyle(.white)
					.cornerRadius()
			}
		)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
		.padding(Constants.UI.Padding.default * 2)
	}
}
