//
//  GroupListView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

@MainActor
struct GroupListView: View {
	@State private var viewModel = ViewModel()
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
					}.onMove { origin, destination in
						Task {
							await viewModel.updateContactGroupOrder(from: origin, to: destination)
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
			await viewModel.fetchContactGroups(refresh: true)
		}
	}

	private var createGroupButton: some View {
		Button(
			action: {
				createGroupView = GroupCreationView(
					viewModel: GroupCreationView.ViewModel {
						Task {
							await viewModel.fetchContactGroups(refresh: true)
						}
						createGroupView = nil
					}
				)
			},
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
