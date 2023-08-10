//
//  ApplicationError+DisplayableError.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

extension ApplicationError: DisplayableSwiftError {
	private var info: (title: String?, message: String?, buttonTitle: String?) {
		switch self {
		case .notImplementedYet:
			return ("Not Implemented Yet", nil, nil)
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
