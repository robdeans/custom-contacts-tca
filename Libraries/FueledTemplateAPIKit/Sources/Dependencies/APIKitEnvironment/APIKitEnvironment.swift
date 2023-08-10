//
//  APIKitEnvironment.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Dependencies
import Foundation
import FueledTemplateHelpers

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
