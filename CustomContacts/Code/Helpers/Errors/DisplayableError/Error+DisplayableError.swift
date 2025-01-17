//
//  Error+DisplayableError.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

extension Error {
	var displayableError: DisplayableError {
		// We need to explicitely cast `self` to Error because by default it's actually of its "actual" type
		// (usually `NSError`), which would use this type's DisplayableError definition rather than
		// the type it's supposed to represent (any Error can be cast to NSError, but it could actually be a custom
		// swift error type). This allow to get the Swift Custom error type and use its DisplayableError implementation
		// rather than to use the default NSError one.
		return (self as Error as? DisplayableSwiftError) ?? self as NSError as DisplayableError
	}
}
