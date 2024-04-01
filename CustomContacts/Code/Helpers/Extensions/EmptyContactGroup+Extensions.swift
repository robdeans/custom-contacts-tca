//
//  EmptyContactGroup+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftUI

extension EmptyContactGroup {
	init(contactGroup: ContactGroup) {
		self.init(
			id: contactGroup.id,
			name: contactGroup.name,
			contactIDs: contactGroup.contactIDs,
			colorHex: contactGroup.colorHex
		)
	}
}

extension EmptyContactGroup {
	var color: Color {
		Color(hex: colorHex)
	}
}
