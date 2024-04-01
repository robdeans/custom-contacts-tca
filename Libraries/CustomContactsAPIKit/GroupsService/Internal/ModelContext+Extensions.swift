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
	///	https://useyourloaf.com/blog/swiftdata-fetching-an-existing-object/
	///
	///	Sample usage:
	///
	/// ```
	///	private static func emptyContactGroup(
	/// for objectID: PersistentIdentifier,
	/// 	in modelContainer: ModelContainer
	/// ) throws -> EmptyContactGroup {
	/// 	let modelContext = ModelContext(modelContainer)
	/// 	guard let data = try modelContext.existingModel(for: objectID) as ContactGroupData? else {
	/// 		throw DataError.noDataFound(id: objectID)
	/// 	}
	///
	/// 	return EmptyContactGroup(contactGroupData: data)
	/// }
	/// ```
	///
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
