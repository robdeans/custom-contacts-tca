//
//  GroupsFeature.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/6/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit

struct GroupsFeature: Reducer {
	struct State: Equatable {
		@PresentationState var addGroup: AddGroupFeature.State?
		var groups: IdentifiedArrayOf<ContactGroup> = []
	}

	enum Action: Equatable {
		case addButtonTapped
		case addGroup(PresentationAction<AddGroupFeature.Action>)
		case fetchGroups
		case updateGroups([ContactGroup])
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .fetchGroups:
				return .run { send in
					@Dependency(\.groupsRepository) var groupsRepository
					let groups = try! groupsRepository.fetchGroups()
					await send(.updateGroups(groups))
				}

			case let .updateGroups(groups):
				state.groups = IdentifiedArrayOf(uniqueElements: groups)
				return .none

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
