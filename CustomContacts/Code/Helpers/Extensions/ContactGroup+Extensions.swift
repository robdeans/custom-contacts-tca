//
//  ContactGroup+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import CustomContactsHelpers
import Dependencies
import SwiftUI

extension ContactGroup {
	var color: Color {
		Color(hex: colorHex)
	}

	static var empty: ContactGroup {
		@Dependency(\.uuid) var uuid
		return ContactGroup.create(
			id: uuid().uuidString,
			name: "",
			contactIDs: [],
			colorHex: Color.random.toHex ?? ""
		)
	}
}
