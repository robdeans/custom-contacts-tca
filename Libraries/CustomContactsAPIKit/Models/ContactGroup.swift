//
//  ContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation
import SwiftData

@Model // TODO: this `@Model` shouldn't be Sendable...?
public final class ContactGroup/*: Sendable*/ {
	public let id: ContactGroup.ID
	public var name: String
	public var contactIDs: Set<Contact.ID>
	public var colorHex: String

	public init(
		id: ContactGroup.ID,
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
	public static var mock: ContactGroup {
		ContactGroup(id: "1", name: "Group Name", contactIDs: Set(Contact.mockArray.map { $0.id }), colorHex: "0000FF")
	}

	public static var mockArray: [ContactGroup] {
		[
			ContactGroup(id: "1", name: "Friendz", contactIDs: Set(Contact.mockArray.map { $0.id }), colorHex: "0000FF"),
			ContactGroup(id: "2", name: "Enemies", contactIDs: Set(Contact.mockArray.map { $0.id }), colorHex: "FF0000"),
			ContactGroup(id: "3", name: "Family", contactIDs: Set(Contact.mockArray.map { $0.id }), colorHex: "00FF00"),
		]
	}
}
