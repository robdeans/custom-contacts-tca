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

	@Published var group = ContactGroup.empty
	@Published var filter = Filter.include
	@Published var `operator` = Operator.or

	init(isFirstQuery: Bool) {
		// First query should be `or` so base group is more inclusive of future clauses
		self.operator = isFirstQuery ? .or : .and
		group = contactsRepository.allContactsGroup
	}
}

extension FilterQuery: Identifiable {
	var id: String {
		uuid().uuidString
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
