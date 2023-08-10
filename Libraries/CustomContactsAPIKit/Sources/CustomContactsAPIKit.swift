//
//  CustomContactsAPIKit.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Dependencies

public enum CustomContactsAPIKit {
	public static func initialize(environment: Environment) {
		@Dependency(\.apiKitEnvironment) var apiKitEnvironment: APIKitEnvironment
		apiKitEnvironment.initialize(with: environment)
	}
}
