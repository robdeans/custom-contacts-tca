//
//  Keychain+Shared.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import KeychainAccess

extension Keychain {
	public static var shared: Keychain { Keychain(service: "com.robertdeans.CustomContacts") }
}
