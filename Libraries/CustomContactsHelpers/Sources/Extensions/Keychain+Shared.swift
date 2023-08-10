//
//  Keychain+Shared.swift
//  CustomContactsHelpers
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import KeychainAccess

extension Keychain {
	public static let shared = Keychain(service: "com.fueled.CustomContacts")
}
