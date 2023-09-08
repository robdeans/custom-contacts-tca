//
//  AddGroupFeature.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/6/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftUI

struct AddGroupFeature: Reducer {
	struct State: Equatable {
		@PresentationState var contactSelector: ContactSelectorFeature.State?
		var group: ContactGroup
	}

	enum Action: Equatable {
		case delegate(Delegate)
		case cancelButtonTapped
		case saveButtonTapped
		case setName(String)
		case setColor(Color)
		case addContactsTapped
		case addContacts(PresentationAction<ContactSelectorFeature.Action>)

		enum Delegate: Equatable {
			case saveGroup(ContactGroup)
		}
	}

	@Dependency(\.dismiss) var dismiss

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .delegate:
				return .none

			case .cancelButtonTapped:
				return .run { _ in await self.dismiss() }

			case .saveButtonTapped:
				return .run { [group = state.group] send in
					@Dependency(\.groupsRepository) var groupsRepository
					try groupsRepository.addGroup(group)
					// TODO: handle error
					await send(.delegate(.saveGroup(group)))
					await self.dismiss()
				}

			case let .setName(name):
				state.group.name = name
				return .none

			case let .setColor(color):
				state.group.colorHex = color.toHex ?? ""
				return .none

			case .addContactsTapped:
				state.contactSelector = ContactSelectorFeature.State()
				return .none

			case .addContacts(.presented(.doneButtonTapped)):
				guard let contactIDs = state.contactSelector?.selectedContactIDs else {
					return .none
				}
				state.group.contactIDs = contactIDs
				return .none

			case .addContacts:
				return .none
			}
		}
		.ifLet(\.$contactSelector, action: /Action.addContacts) {
			ContactSelectorFeature()
		}
	}
}
