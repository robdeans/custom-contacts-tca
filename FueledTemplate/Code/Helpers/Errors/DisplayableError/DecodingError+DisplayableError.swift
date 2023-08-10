//
//  DecodingError+DisplayableError.swift
//  FueledTemplate
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

extension CodingKey {
	fileprivate func userFriendlyDescription(isFirstKey: Bool = true) -> String {
		if let index = intValue {
			return "[\(index)]"
		}
		return "\(isFirstKey ? "" : ".")\(stringValue)"
	}
}

extension DecodingError.Context {
	fileprivate var keyPath: String {
		"\"\(codingPath.enumerated().map { $0.element.userFriendlyDescription(isFirstKey: $0.offset == 0) }.joined())\""
	}
}

extension DecodingError: DisplayableSwiftError {
	private var info: (title: String?, message: String?, buttonTitle: String?) {
		let message: String
		switch self {
		case .typeMismatch(let type, let context):
			message = "The type for keypath \(context.keyPath) doesn't match the type \(type)"
		case .valueNotFound(let type, let context):
			message = "There was a `null` value found for the required property at keypath \(context.keyPath) (expected type: \(type))"
		case .keyNotFound(let codingKey, let context):
			message = "There was no key found for the key \(codingKey.userFriendlyDescription()) required property at keypath \(context.keyPath))"
		case .dataCorrupted(let context):
			message = "Data at keypath \(context.keyPath) is corrupted"
		@unknown default:
			message = "\(self)"
		}
		return (nil, message, nil)
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
