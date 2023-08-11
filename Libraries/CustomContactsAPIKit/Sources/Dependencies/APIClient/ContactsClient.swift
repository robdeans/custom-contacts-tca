//
//  ContactsClient.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 8/11/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Contacts

protocol ContactsClient {
	func fetchContacts() async throws -> [Contact]
	func getAuthorizationStatus() async throws -> Bool
}

final class ContactsClientLive: ContactsClient {
	private static let store = CNContactStore()
	private static let keysToFetch: [Any] = [
		CNContactGivenNameKey,
		CNContactFamilyNameKey,
		CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
	]

	func fetchContacts() async throws -> [Contact] {
		let request = CNContactFetchRequest(keysToFetch: (Self.keysToFetch as! [CNKeyDescriptor]))
		return try await withCheckedThrowingContinuation { continuation in
			do {
				var contacts: [Contact] = []
				try Self.store.enumerateContacts(with: request) { cnContact, _ in
					contacts.append(Contact(cnContact))
				}
				continuation.resume(returning: contacts)
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}

	func getAuthorizationStatus() async throws -> Bool {
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
