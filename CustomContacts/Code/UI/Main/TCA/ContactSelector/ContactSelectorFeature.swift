//
//  ContactSelectorFeature.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit

struct ContactSelectorFeature: Reducer {
	struct State: Equatable {
		var contacts: [Contact] = []
		var selectedContactIDs: Set<Contact.ID> = []
		var searchText = ""
	}

	enum Action: Equatable {
		case delegate(Delegate)
		case cancelButtonTapped
		case setSearchText(String)
		case updateContactIDs(Set<Contact.ID>)
		case doneButtonTapped
		case loadContacts(refresh: Bool)
		case updateContacts([Contact])

		enum Delegate: Equatable {
			case saveContactIDs(Set<Contact.ID>)
		}
	}

	// private?
	@Dependency(\.dismiss) var dismiss

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .delegate:
				return .none

			case .cancelButtonTapped:
				return .run { _ in await self.dismiss() }

			case let .loadContacts(refresh):
				return .run { send in
					@Dependency(\.contactsRepository) var contactsRepository
					let contacts = try await contactsRepository.getContacts(refresh: refresh)
					// TODO: handle error
					await send(.updateContacts(contacts))
				}

			case let .updateContacts(contacts):
				state.contacts = contacts
				return .none

			case let .setSearchText(text):
				state.searchText = text
				return .none

			case let .updateContactIDs(contactIDs):
				state.selectedContactIDs = contactIDs
				return .none

			case .doneButtonTapped:
				return .run { [contactIDs = state.selectedContactIDs] send in
					await send(.delegate(.saveContactIDs(contactIDs)))
					await self.dismiss()
				}
			}
		}
	}
}

extension ContactSelectorFeature.State {
	var contactsDisplayable: [Contact] {
		if !searchText.isEmpty {
			return contacts.filter {
				// TODO: improve search filtering
				$0.fullName.lowercased().contains(searchText.lowercased())
			}
		}
		return contacts
	}
}
