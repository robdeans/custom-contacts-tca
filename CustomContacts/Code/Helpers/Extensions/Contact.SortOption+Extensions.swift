//
//  Contact.SortOption+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 1/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftyUserDefaults

extension Contact.SortOption: DefaultsSerializable {
	static var current: Contact.SortOption {
		Defaults[\.contactsSortOption]
	}
}

extension DefaultsKeys {
	var contactsSortOption: DefaultsKey<Contact.SortOption> {
		.init(
			"contactsSortOption",
			defaultValue: Contact.SortOption(parameter: .lastName, ascending: true)
		)
	}
}
