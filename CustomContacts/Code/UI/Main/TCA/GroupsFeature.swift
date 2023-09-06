//
//  GroupsFeature.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/6/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftData

struct GroupsFeature: Reducer {
	struct State: Equatable {
		@PresentationState var addGroup: AddGroupFeature.State?
		var groups: IdentifiedArrayOf<ContactGroup> = []
	}

	enum Action: Equatable {
		case addButtonTapped
		case addGroup(PresentationAction<AddGroupFeature.Action>)
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.addGroup = AddGroupFeature.State(
					group: .empty
				)
				return .none

			case .addGroup(.presented(.saveButtonTapped)):
				guard let group = state.addGroup?.group else {
					return .none
				}
				state.groups.append(group)
				return .none

			case .addGroup:
				return .none
			}
		}
		.ifLet(\.$addGroup, action: /Action.addGroup) {
			AddGroupFeature()
		}
	}
}

import SwiftUI

struct GroupsView: View {
	let store: StoreOf<GroupsFeature>

	var body: some View {
		NavigationStack {
			WithViewStore(self.store, observe: \.groups) { viewStore in
				List {
					ForEach(viewStore.state) { group in
						Text(group.name)
					}
				}
				.navigationTitle("Groups")
				.toolbar {
					ToolbarItem {
						Button {
							viewStore.send(.addButtonTapped)
						} label: {
							Image(systemName: "plus")
						}
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
}

#Preview {
	MainActor.assumeIsolated {
		let container = previewContainer
		return GroupsView(
			store: Store(
				initialState: GroupsFeature.State(
					groups: IdentifiedArrayOf(uniqueElements: ContactGroup.mockArray)
				)
			) {
				GroupsFeature()
			}
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
