//
//  ApplicationError+DisplayableError.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
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
