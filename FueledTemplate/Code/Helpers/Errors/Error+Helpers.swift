//
//  Error+Helpers.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation
import FueledTemplateHelpers

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
