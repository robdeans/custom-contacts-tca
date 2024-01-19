//
//  ContactsService+Live.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Contacts
import CustomContactsHelpers
import CustomContactsModels

final class ContactsServiceLive: ContactsService {
	private static let store = CNContactStore()
	private static let keysToFetch: [Any] = [
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

	func fetchContacts() async throws -> [Contact] {
		let request = CNContactFetchRequest(keysToFetch: Self.keysToFetch.compactMap { $0 as? CNKeyDescriptor })
		return try await withCheckedThrowingContinuation { continuation in
			do {
				var contacts: [Contact] = []
				try Self.store.enumerateContacts(with: request) { cnContact, _ in
					contacts.append(Contact(cnContact))
				}
				LogInfo("Returnings \(contacts.count) contacts")
				continuation.resume(returning: contacts)
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}

	func requestPermissions() async throws -> Bool {
		switch CNContactStore.authorizationStatus(for: .contacts) {
		case .authorized:
			return true
		case .notDetermined:
			do {
				return try await Self.store.requestAccess(for: .contacts)
			} catch {
				throw error
			}
		case .restricted, .denied:
			return false
		@unknown default:
			return false
		}
	}
}
