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
