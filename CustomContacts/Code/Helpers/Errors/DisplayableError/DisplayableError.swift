//
//  DisplayableError.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

protocol DisplayableError: Error {
	var title: String? { get }
	var message: String? { get }
	var buttonTitle: String? { get }
}

protocol DisplayableSwiftError: DisplayableError, SwiftError {
}
