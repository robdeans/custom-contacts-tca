//
//  App.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

@main
struct CustomContactsApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

	var body: some Scene {
		WindowGroup {
			MarvelHeroesView()
		}
	}
}
