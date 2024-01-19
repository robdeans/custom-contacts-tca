//
//  EnvironmentApplicationService.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024
//  Copyright © 2023 RBD. All rights reserved.
//

import Dependencies
import UIKit

enum DefaultKeys {
	fileprivate static var environmentName: String = "environmentName"
}

final class EnvironmentApplicationService: NSObject, ApplicationService {
	override init() {
		let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!
		let settingsBundle = Bundle(url: settingsBundleURL)!
		// Iterate over all .plist in the settings bundle
		for url in settingsBundle.urls(forResourcesWithExtension: "plist", subdirectory: nil) ?? [] {
			let plistContent = NSDictionary(contentsOf: url) as! [String: Any]
			let settings = plistContent["PreferenceSpecifiers"] as! [[String: Any]]
			var defaults: [String: Any] = [:]
			for setting in settings {
				if let key = setting["Key"] as? String, let defaultValue = setting["DefaultValue"] {
					defaults[key] = defaultValue
				}
			}
			UserDefaults.standard.register(defaults: defaults)
		}
	}
}
