//
//  FilterQuery.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/31/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CustomContactsAPIKit
import Dependencies

final class FilterQuery: ObservableObject {
	@Dependency(\.uuid) private var uuid
	@Dependency(\.contactsRepository) private var contactsRepository

	@Published var group: ContactGroup?
	@Published var relation = Relation.included
	@Published var andOr = AndOr.or

	init(isFirstQuery: Bool) {
		// First query should be `or` so base group is as open as possible
		andOr = isFirstQuery ? .or : .and
		group = contactsRepository.allContactsGroup
	}
}

extension FilterQuery: Identifiable {
	var id: String {
		uuid().uuidString
	}
}

extension FilterQuery {
	enum Relation: String, CaseIterable {
		case included
		case excluded

		var id: String {
			rawValue
		}
	}

	enum AndOr: String, CaseIterable {
		case and
		case or

		var id: String {
			rawValue
		}
	}
}
