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

@MainActor
struct GroupListView: View {
	@StateObject private var viewModel = ViewModel()
	@StateObject private var groupListNavigation = GroupListNavigation()
	@State private var createGroupView: GroupCreationView?

	var body: some View {
		NavigationStack(path: $groupListNavigation.path) {
			ZStack {
				List {
					ForEach(viewModel.contactGroups) { group in
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
		.environmentObject(groupListNavigation)
		.task {
			await viewModel.fetchContactGroups()
		}
		.refreshable {
			await viewModel.fetchContactGroups()
		}
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

import CustomContactsHelpers
import Dependencies

extension GroupListView {
	// TODO: why no @Observation work here?
	final class ViewModel: ObservableObject {
		@Published private(set) var contactGroups: [ContactGroup] = []

		@MainActor
		func fetchContactGroups(refresh: Bool = false) async {
			@Dependency(\.groupsRepository) var groupsRepository
			do {
				contactGroups = try await groupsRepository.fetchContactGroups(refresh: refresh)
				LogTrace("Fetched \(self.contactGroups.count) ContactGroup(s)")
			} catch {
				LogError("Error fetching groups!")
				// TODO: show error
			}
		}
	}
}
