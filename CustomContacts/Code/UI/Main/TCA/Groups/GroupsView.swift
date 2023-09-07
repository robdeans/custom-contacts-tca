//
//  GroupsView.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftData
import SwiftUI

struct GroupsView: View {
	let store: StoreOf<GroupsFeature>

	// TODO: TCA refactor
	let onToggleTapped: () -> Void

	var body: some View {
		NavigationStack {
			ZStack {
				WithViewStore(self.store, observe: \.groups) { viewStore in
					List {
						ForEach(viewStore.state) { group in
							GroupCardView(group: group) {
								//groupDetailView = GroupDetailView(group: group)
							}
						}
					}
				}

				createGroupButton
			}
			.navigationTitle(Localizable.Root.Groups.title)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("🔄") {
						onToggleTapped()
					}
				}
			}
		}
		.sheet(
			store: self.store.scope(
				state: \.$addGroup,
				action: { .addGroup($0) }
			)
		) { addGroupStore in
			NavigationStack {
				AddGroupView(store: addGroupStore)
			}
		}
	}

	private var createGroupButton: some View {
		Button(
			action: { store.send(.addButtonTapped) },
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

#Preview {
	MainActor.assumeIsolated {
		let container = previewContainer
		return GroupsView(
			store: Store(
				initialState: GroupsFeature.State(
					groups: IdentifiedArrayOf(uniqueElements: ContactGroup.mockArray)
				),
				reducer: { GroupsFeature() }
			),
			onToggleTapped: {}
		)
		.modelContainer(container)
	}
}

@MainActor
private let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(for: ContactGroup.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
		container.mainContext.insert(ContactGroup.mock)
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
