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
		@PresentationState var alert: AlertState<Action.Alert>?

		var groups: IdentifiedArrayOf<ContactGroup> = []
	}

	enum Action: Equatable {
		case addButtonTapped
		case addGroup(PresentationAction<AddGroupFeature.Action>)
		case fetchGroups
		case groupsResponse([ContactGroup])
		case error(GroupsError)
		case alert(PresentationAction<Alert>)

		enum Alert: Equatable {
			case retry
		}
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .fetchGroups:
				return .run { send in
					@Dependency(\.groupsRepository) var groupsRepository
					do {
						let groups = try groupsRepository.fetchGroups()
						await send(.groupsResponse(groups))
					} catch {
						// TODO: better way to enforce errors?
						await send(.error(error as! GroupsError))
					}
				}

			case let .groupsResponse(groups):
				state.groups = IdentifiedArrayOf(uniqueElements: groups)
				return .none

			case let .error(error):
				state.alert = AlertState {
					TextState(error.userFriendlyDescription)
				} actions: {
					ButtonState(role: .cancel) {
						TextState(Localizable.Common.Actions.cancel)
					}
					ButtonState(action: .retry) {
						TextState(Localizable.Common.Actions.retry)
					}
				}
				return .none

			case .alert(.presented(.retry)):
				return .send(.fetchGroups)

			case .alert:
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
