//
//  EmptyContactGroup.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

public struct EmptyContactGroup: Sendable, Identifiable {
	public typealias ID = String

	public let id: EmptyContactGroup.ID
	public let name: String
	public let contactIDs: Set<Contact.ID>
	public let colorHex: String
	public let index: Int

	public init(id: EmptyContactGroup.ID, name: String, contactIDs: Set<Contact.ID>, colorHex: String, index: Int) {
		self.id = id
		self.name = name
		self.contactIDs = contactIDs
		self.colorHex = colorHex
		self.index = index
	}
}

extension EmptyContactGroup: Equatable {
	public static func == (lhs: EmptyContactGroup, rhs: EmptyContactGroup) -> Bool {
		lhs.id == rhs.id
		&& lhs.name == rhs.name
		&& lhs.contactIDs == rhs.contactIDs
		&& lhs.colorHex == rhs.colorHex
		&& lhs.index == rhs.index
	}
}
