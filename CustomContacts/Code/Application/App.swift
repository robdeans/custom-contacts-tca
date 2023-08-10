//
//  App.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

@main
struct CustomContactsApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	@ObservedObject private var viewModel = ContactsListViewModel()

	var body: some Scene {
		WindowGroup {
			List {
				ForEach(viewModel.contacts) {
					Text($0.fullName)
				}
			}
		}
	}
}

@MainActor
final class ContactsListViewModel: ObservableObject {
	@Published private(set) var contacts: [Contact] = []

	init() {
		Task {
			do {
				guard try await ContactsService.liveValue.requestContactsPermissions() else {
					// Permissions denied state
					return
				}
				contacts = try await ContactsService.liveValue.fetchContacts()
			} catch {
				//show error
			}
		}
	}
}
