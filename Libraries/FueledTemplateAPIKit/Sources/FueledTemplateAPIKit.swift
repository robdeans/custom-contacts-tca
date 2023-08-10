//
//  FueledTemplateAPIKit.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Dependencies

public enum FueledTemplateAPIKit {
	public static func initialize(environment: Environment) {
		@Dependency(\.apiKitEnvironment) var apiKitEnvironment: APIKitEnvironment
		apiKitEnvironment.initialize(with: environment)
	}
}
