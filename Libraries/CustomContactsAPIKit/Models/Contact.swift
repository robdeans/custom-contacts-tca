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
	public let groups: [EmptyContactGroup]
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
		groups = []
	}

	public func adding(group: EmptyContactGroup) -> Contact {
		Contact(
			id: id,
			firstName: firstName,
			lastName: lastName,
			displayName: displayName,
			groups: groups + [group]
		)
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
