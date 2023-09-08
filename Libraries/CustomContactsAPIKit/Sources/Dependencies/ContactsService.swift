//
//  ContactsService.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/10/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Contacts
import Dependencies

public protocol ContactsService {
	func fetchContacts() async throws -> [Contact]
	func requestPermissions() async throws -> Bool
}

private enum ContactsServiceKey: DependencyKey {
	static let liveValue: ContactsService = ContactsServiceLive()
	static let previewValue: ContactsService = ContactsServiceLive()
}

extension DependencyValues {
	public var contactsService: ContactsService {
		get { self[ContactsServiceKey.self] }
		set { self[ContactsServiceKey.self] = newValue }
	}
}

final class ContactsServiceLive: ContactsService {
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

final class ContactsServiceMock: ContactsService {
	func fetchContacts() async throws -> [Contact] {
		Contact.mockArray
	}

	func requestPermissions() async throws -> Bool {
		true
	}
}
