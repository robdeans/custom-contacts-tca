//
//  Contact+Mocks.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

extension Contact {
	public static let mock = Contact(
		id: "123",
		firstName: "Tina",
		lastName: "Belcher",
		displayName: "Tina Belcher",
		groups: []
	)

	public static let mockArray = [
		Contact(
			id: "123",
			firstName: "Tina",
			lastName: "Belcher",
			displayName: "Tina Belcher",
			groups: []
		),
		Contact(
			id: "456",
			firstName: "Bob",
			lastName: "Belcher",
			displayName: "Bob Belcher",
			groups: []
		),
		Contact(
			id: "789",
			firstName: "Gene",
			lastName: "Belcher",
			displayName: "Gene Belcher",
			groups: []
		),
	]
}
