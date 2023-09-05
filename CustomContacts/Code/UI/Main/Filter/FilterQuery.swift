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

final class FilterQuery: ObservableObject, Identifiable {
	let id: String

	@Published var group: ContactGroup
	@Published var filter = Filter.include
	@Published var `operator` = Operator.or

	init(isFirstQuery: Bool) {
		// First query should be `or` so base group is more inclusive of future clauses
		self.operator = isFirstQuery ? .or : .and

		@Dependency(\.uuid) var uuid
		self.id = uuid().uuidString

		@Dependency(\.contactsRepository) var contactsRepository
		group = contactsRepository.allContactsGroup
	}
}

extension FilterQuery {
	enum Filter: String, CaseIterable {
		case include
		case exclude
	}

	enum Operator: String, CaseIterable {
		case and
		case or
	}
}
