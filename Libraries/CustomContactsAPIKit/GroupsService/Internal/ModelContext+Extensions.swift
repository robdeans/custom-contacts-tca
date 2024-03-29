//
//  ModelContext+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation
import SwiftData

extension ModelContext {
	func existingModel<T>(for objectID: PersistentIdentifier) throws -> T? where T: PersistentModel {
		if let registered: T = registeredModel(for: objectID) {
			return registered
		}

		let fetchDescriptor = FetchDescriptor<T>(
			predicate: #Predicate {
				$0.persistentModelID == objectID
			}
		)

		return try fetch(fetchDescriptor).first
	}
}
