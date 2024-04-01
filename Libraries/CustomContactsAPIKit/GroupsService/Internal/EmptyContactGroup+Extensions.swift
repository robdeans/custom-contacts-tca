//
//  Contact+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels

extension EmptyContactGroup {
	init(contactGroupData: ContactGroupData) {
		self.init(
			id: contactGroupData.id,
			name: contactGroupData.name,
			contactIDs: contactGroupData.contactIDs,
			colorHex: contactGroupData.colorHex,
			index: contactGroupData.index
		)
	}
}
