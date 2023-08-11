//
//  Contact.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Contacts

public struct Contact: Identifiable {
	public let id: Contact.ID
	public var firstName: String
	public var lastName: String
//	public var groups: Set<ContactGroup>
}

extension Contact {
	public typealias ID = String

	init(_ cnContact: CNContact) {
		id = cnContact.identifier
		firstName = cnContact.givenName
		lastName = cnContact.familyName
	}

	// TODO: This should use NameFormatter to leverage locale
	public var fullName: String {
		[firstName, lastName].compactMap { $0 }.joined(separator: " ")
	}
}

extension Contact: Hashable {
	public static func == (lhs: Contact, rhs: Contact) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension Contact {
	public static let mock = Contact(
		id: "123",
		firstName: "Tina",
		lastName: "Belcher"
	)
}

/*
extension Contact {
	func adding(group: ContactGroup) -> Contact {
		Contact(
			id: self.id,
			firstName: self.firstName,
			lastName: self.lastName,
			groups: self.groups.union(Set([group]))
		)
	}

	// TODO: Could this be more efficient? Is re-writing possible or is removing/re-adding necessary
	func updating(group: ContactGroup) -> Contact {
		self.removing(group: group)
			.adding(group: group)
	}

	func removing(group: ContactGroup) -> Contact {
		Contact(
			id: self.id,
			firstName: self.firstName,
			lastName: self.lastName,
			groups: self.groups.subtracting(Set([group]))
		)
	}
}
*/
