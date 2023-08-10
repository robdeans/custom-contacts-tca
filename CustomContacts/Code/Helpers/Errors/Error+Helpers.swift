//
//  Error+Helpers.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation
import CustomContactsHelpers

extension Error {
	var verboseDescription: String {
		"<[\(self)]: Title=\(displayableError.title ?? "(default)") Description=\(displayableError.message ?? "(default)") ButtonTitle=\(displayableError.buttonTitle ?? "(default)")>"
	}

	var userFriendlyTitle: String? {
		LogError("Error \(self): \(verboseDescription)")
		return displayableError.title
	}

	var userFriendlyMessage: String? {
		LogError("Error \(self): \(verboseDescription)")
		return displayableError.message
	}

	var userFriendlyDescription: String {
		LogError("Error \(self): \(verboseDescription)")
		return displayableError.message ?? displayableError.title ?? localizedDescription
	}
}
