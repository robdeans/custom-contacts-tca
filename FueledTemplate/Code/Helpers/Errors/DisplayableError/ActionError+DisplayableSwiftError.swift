//
//  ActionError+DisplayableSwiftError.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Combine
import FueledUtilsCombine

extension ActionError: DisplayableSwiftError {
	private var info: (title: String?, message: String?, buttonTitle: String?) {
		switch self {
		case .disabled:
			return ("Error", "This can't be done right now. Please try again in a few seconds.", nil)
		case .failure(let error):
			let displayableError = error.displayableError
			return (displayableError.title, displayableError.message, displayableError.buttonTitle)
		}
	}

	var title: String? {
		info.title
	}

	var message: String? {
		info.message
	}

	var buttonTitle: String? {
		info.buttonTitle
	}
}
