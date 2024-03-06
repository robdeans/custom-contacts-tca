//
//  Contact.SortOption+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 1/29/24.
//  Copyright © 2024 RBD. All rights reserved.
//

import CustomContactsModels

extension Contact.SortOption { //}: DefaultsSerializable {
	static var current: Contact.SortOption {
		// TODO: add Defaults property wrapper
		// Defaults[\.contactsSortOption]
		Contact.SortOption(parameter: .firstName, ascending: true)
	}
}

//extension DefaultsKeys {
//	var contactsSortOption: DefaultsKey<Contact.SortOption> {
//		.init(
//			"contactsSortOption",
//			defaultValue: Contact.SortOption(parameter: .lastName, ascending: true)
//		)
//	}
//}
