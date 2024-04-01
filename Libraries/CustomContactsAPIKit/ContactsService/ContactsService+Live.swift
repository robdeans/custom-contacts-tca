//
//  ContactsService+Live.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

extension ContactsService {
	// Possible improvement for syncing:
	// https://developer.apple.com/documentation/foundation/nsnotification/name/1403253-cncontactstoredidchange
	public static var liveValue: Self {
		let contactsHandler = ContactStoreHandler()
		return Self(
			fetchContacts: {
				try await contactsHandler.fetchContacts()
			},
			requestPermissions: {
				try await contactsHandler.requestPermissions()
			}
		)
	}
}
