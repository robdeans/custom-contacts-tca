//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class ContactGroupData {
	public let id: ContactGroupData.ID
	public var name: String
	public var contactIDs: Set<Contact.ID>
	public var colorHex: String

	public init(
		id: ContactGroupData.ID,
		name: String,
		contactIDs: Set<Contact.ID>,
		colorHex: String
	) {
		self.id = id
		self.name = name
		self.contactIDs = contactIDs
		self.colorHex = colorHex
	}
}

extension ContactGroupData {
	public typealias ID = String
}
