//
//  App.swift
//  CustomContacts
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
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
