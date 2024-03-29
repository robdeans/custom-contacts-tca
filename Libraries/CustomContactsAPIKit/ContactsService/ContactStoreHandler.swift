//
//  ContactStoreHandler.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

@preconcurrency import Contacts
import CustomContactsHelpers
import CustomContactsModels

actor ContactStoreHandler {
	private lazy var store = CNContactStore()

	private static var keysToFetch: [Any] {
		[
			CNContactIdentifierKey,
			CNContactTypeKey,
			CNContactGivenNameKey,
			CNContactFamilyNameKey,
			CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
			CNContactOrganizationNameKey,
			CNContactEmailAddressesKey,
			CNContactPostalAddressesKey,
			CNContactPhoneNumbersKey,
		]
	}

	func fetchContacts() async throws -> [Contact] {
		LogCurrentThread("ContactStoreHandler.fetchContacts")
		let request = CNContactFetchRequest(keysToFetch: Self.keysToFetch.compactMap { $0 as? CNKeyDescriptor })
		return try await withCheckedThrowingContinuation { continuation in
			do {
				var contacts: [Contact] = []
				try store.enumerateContacts(with: request) { cnContact, _ in
					contacts.append(Contact(cnContact))
				}
				LogInfo("ContactStore returning \(contacts.count) contact(s)")
				continuation.resume(returning: contacts)
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}
	func requestPermissions() async throws -> Bool {
		LogCurrentThread("ContactStoreHandler.requestPermissions")
		let contactsAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
		switch contactsAuthorizationStatus {
		case .authorized:
			return true
		case .notDetermined:
			do {
				return try await store.requestAccess(for: .contacts)
			} catch {
				throw error
			}
		case .restricted, .denied:
			return false
		@unknown default:
			LogWarning("Unknown Contact permissions case: \(contactsAuthorizationStatus)")
			return false
		}
	}
}
