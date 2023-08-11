//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftData

@Model
public final class ContactGroup {
	public let id: ContactGroup.ID
	public var name: String
	public var contactIDs: Set<Contact.ID>
//	public var color: Color

	public init(id: ContactGroup.ID, name: String, contactIDs: Set<Contact.ID>) {
		self.id = id
		self.name = name
		self.contactIDs = contactIDs
	}
}

extension ContactGroup {
	public typealias ID = String
}

extension ContactGroup: Hashable {
	public static func == (lhs: ContactGroup, rhs: ContactGroup) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension ContactGroup {
	static let mock = ContactGroup(id: "1", name: "Group", contactIDs: [])
}
