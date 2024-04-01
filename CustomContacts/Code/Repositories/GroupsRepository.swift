//
//  GroupsRepository.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/28/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import Foundation
import SwiftData

@ModelActor
private actor ContactGroupHandler {
	func fetchGroupIDs() throws -> [PersistentIdentifier] {
		let groups = try modelContext.fetch(FetchDescriptor<ContactGroupData>())
		LogInfo("\(groups)")
		return groups.map { $0.persistentModelID }
	}

	@discardableResult
	func createGroup(
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) throws -> PersistentIdentifier {
		LogCurrentThread("ContactGroupHandler")

		@Dependency(\.uuid) var uuid

		let newGroup = ContactGroupData(
			id: uuid().uuidString,
			name: name,
			contactIDs: contactIDs,
			colorHex: colorHex
		)
		modelContext.insert(newGroup)
		try modelContext.save()
		return newGroup.persistentModelID
	}
}

extension DependencyValues {
	var groupsDataService: ContactGroupDataService {
		get { self[ContactGroupDataService.self] }
		set { self[ContactGroupDataService.self] = newValue }
	}
}

struct ContactGroupDataService: Sendable {
	var fetchContactGroups: @Sendable () async throws -> [ContactGroup]
	var createContactGroup: @Sendable (String, Set<Contact.ID>, String) async throws -> ContactGroup
}

extension ContactGroupDataService: DependencyKey {
	static var liveValue: ContactGroupDataService {
		// TODO: is this the safest way to obtain a modelContainer? Seems necessary to keep data in sync
		let modelContainer = try! ModelContainer(for: ContactGroupData.self)
		return Self(
			fetchContactGroups: {
				let contactGroupHandler = ContactGroupHandler(modelContainer: modelContainer)
				let groupPersistentIdentifiers = try await contactGroupHandler.fetchGroupIDs()

				var contactGroups: [ContactGroup] = []
				// TODO: handle each failure individually?
				try await withThrowingTaskGroup(of: ContactGroup.self) { group in
					for objectID in groupPersistentIdentifiers {
						group.addTask {
							return try await Self.getContactGroup(for: objectID, modelContainer: modelContainer)
						}
					}
					for try await contactGroup in group {
						contactGroups.append(contactGroup)
					}
				}
				return contactGroups
			},
			createContactGroup: { name, contactIDs, colorHex in
				let contactGroupHandler = ContactGroupHandler(modelContainer: modelContainer)

				async let objectID = try await contactGroupHandler.createGroup(
					name: name,
					contactIDs: contactIDs,
					colorHex: colorHex
				)
				let createdContactGroup = try await Self.getContactGroup(for: objectID, modelContainer: modelContainer)
				return createdContactGroup
			}
		)
	}
}

extension ContactGroupDataService {
	enum DataError: Error {
		case noDataFound(id: PersistentIdentifier)
	}
	private static func getContactGroup(for objectID: PersistentIdentifier, modelContainer: ModelContainer) async throws -> ContactGroup {
		let modelContext = ModelContext(modelContainer)
		guard let data = try modelContext.existingModel(for: objectID) as ContactGroupData? else {
			LogError("No ContactGroup found... ID: \(objectID)")
			throw DataError.noDataFound(id: objectID)
		}
		// Copy to allow values to be Sendable
		let id = data.id
		let name = data.name
		let contactIDs = data.contactIDs
		let colorHex = data.colorHex

		return await ContactGroup(
			id: id,
			name: name,
			contactIDs: contactIDs,
			colorHex: colorHex
		)
	}
}

fileprivate extension ModelContext {
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
