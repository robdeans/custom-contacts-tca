//
//  Environment.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

public enum Environment: String, Codable, CaseIterable {
	case development = "dev"
	case qa
	case production = "prod"
}

extension Environment {
	var baseURL: URL {
		switch self {
		case .development:
			return URL(string: "https://gateway.marvel.com")!
		case .qa:
			return URL(string: "https://gateway.marvel.com")!
		case .production:
			return URL(string: "https://gateway.marvel.com")!
		}
	}
}
