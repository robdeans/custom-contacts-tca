//
//  Contact.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Contacts
import CustomContactsHelpers

public struct Contact: Identifiable, Sendable {
	public let id: Contact.ID
	public let firstName: String
	public let lastName: String
	public let displayName: String
}

extension Contact {
	private static var contactNameFormatter: CNContactFormatter {
		let formatter = CNContactFormatter()
		formatter.style = .fullName
		return formatter
	}
}

extension Contact {
	public typealias ID = String

	public init(_ cnContact: CNContact) {
		id = cnContact.identifier
		firstName = cnContact.givenName
		lastName = cnContact.familyName
		displayName = Self.contactNameFormatter.string(from: cnContact)
		?? cnContact.emailAddresses.first.map { String($0.value) }
		?? cnContact.phoneNumbers.first.map { String($0.value.stringValue) }
		?? ""
		if displayName.isEmpty {
			LogWarning("Blank displayName: \(cnContact)")
		}
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
		lastName: "Belcher",
		displayName: "Tina Belcher"
	)

	public static let mockArray = [
		Contact(
			id: "123",
			firstName: "Tina",
			lastName: "Belcher",
			displayName: "Tina Belcher"
		),
		Contact(
			id: "456",
			firstName: "Bob",
			lastName: "Belcher",
			displayName: "Bob Belcher"
		),
		Contact(
			id: "789",
			firstName: "Gene",
			lastName: "Belcher",
			displayName: "Gene Belcher"
		),
	]
}
