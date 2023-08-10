//
//  String+Localization.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import UIKit

extension String {
	func localized(table: String? = nil, withComment comment: String = "") -> String {
		LocalizableKey(self).localized(table: table)
	}

	func localizedFormat(table: String? = nil, withComment comment: String = "", _ args: CVarArg...) -> String {
		LocalizableKey(self).localizedFormat(table: table, args)
	}

	func localizedFormat(table: String? = nil, withComment comment: String = "", _ args: [CVarArg]) -> String {
		LocalizableKey(self).localizedFormat(table: table, args)
	}

	var isValidEmail: Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
	}
}
