//
//  ContactsService+Mock.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels

final class ContactsServiceMock: ContactsService {
	func fetchContacts() async throws -> [Contact] {
		Contact.mockArray
	}

	func requestPermissions() async throws -> Bool {
		true
	}
}
