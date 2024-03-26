//
//  ContactGroupHandler.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/26/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftData

@ModelActor
actor ContactGroupHandler {
	@discardableResult
	func create(group: ContactGroup) throws -> ContactGroup? {
		modelContext.insert(group)
		try modelContext.save()
		return group
	}
}
