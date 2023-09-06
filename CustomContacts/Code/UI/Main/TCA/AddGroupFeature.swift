//
//  AddGroupFeature.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/6/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftData
import SwiftUI

struct AddGroupFeature: Reducer {
	struct State: Equatable {
		var group: ContactGroup
	}

	enum Action: Equatable {
		case delegate(Delegate)
		case cancelButtonTapped
		case saveButtonTapped
		case setName(String)

		enum Delegate: Equatable {
			case saveGroup(ContactGroup)
		}
	}

	@Dependency(\.dismiss) var dismiss
	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .delegate:
			return .none

		case .cancelButtonTapped:
			return .run { _ in await self.dismiss() }

		case .saveButtonTapped:
			return .run { [group = state.group] send in
				await send(.delegate(.saveGroup(group)))
				await self.dismiss()
			}

		case let .setName(name):
			state.group.name = name
			return .none
		}
	}
}

struct AddGroupView: View {
	let store: StoreOf<AddGroupFeature>

	var body: some View {
		WithViewStore(
			self.store,
			observe: { $0 },
			content: { viewStore in
				Form {
					TextField("Name", text: viewStore.binding(get: \.group.name, send: { .setName($0) }))
					Button("Save") {
						viewStore.send(.saveButtonTapped)
					}
				}
				.toolbar {
					ToolbarItem {
						Button("Cancel") {
							viewStore.send(.cancelButtonTapped)
						}
					}
				}
			}
		)
	}
}

#Preview {
	let container = previewContainer
	return MainActor.assumeIsolated {
		NavigationStack {
			AddGroupView(
				store: Store(
					initialState: AddGroupFeature.State(
						group: ContactGroup.empty
					)
				) {
					AddGroupFeature()
				}
			)
		}
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
