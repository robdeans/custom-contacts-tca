//
//  APIKitEnvironment.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import Dependencies
import Foundation

final class APIKitEnvironment: DependencyKey {
	private var currentEnvironment: Environment?

	func initialize(with environment: Environment) {
		currentEnvironment = environment
	}
}

extension APIKitEnvironment {
	var environment: Environment {
		guard let currentEnvironment else {
			LogFatal("Environment not set. Initialize environment using apiKitEnvironment.initialize(with environment:)")
		}
		return currentEnvironment
	}
}

extension DependencyValues {
	var apiKitEnvironment: APIKitEnvironment {
		get { self[APIKitEnvironment.self] }
		set { self[APIKitEnvironment.self] = newValue }
	}
}

extension APIKitEnvironment {
	static var liveValue = APIKitEnvironment()
}
