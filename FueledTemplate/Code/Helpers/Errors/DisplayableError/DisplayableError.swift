//
//  DisplayableError.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

protocol DisplayableError: Error {
	var title: String? { get }
	var message: String? { get }
	var buttonTitle: String? { get }
}

protocol DisplayableSwiftError: DisplayableError, SwiftError {
}
