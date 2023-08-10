//
//  NSAttributedString+LocalizedFormat.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

private final class LocalizableKeyBundleHelper {}

public struct LocalizableKey {
	private let key: String

	public init(_ key: String) {
		self.key = key
	}

	public func localized(table: String? = nil, withComment comment: String = "") -> String {
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil,
			 let languagesBundlePath = Bundle(for: LocalizableKeyBundleHelper.self).path(forResource: "en", ofType: "lproj"),
			 let languagesBundle = Bundle(path: languagesBundlePath) {
			return NSLocalizedString(key, tableName: table, bundle: languagesBundle, comment: comment)
		}
		return NSLocalizedString(key, tableName: table, comment: comment)
	}

	public func localizedFormat(table: String? = nil, withComment comment: String = "", _ args: CVarArg...) -> String {
		localizedFormat(table: table, withComment: comment, args)
	}

	public func localizedFormat(table: String? = nil, withComment comment: String = "", _ args: [CVarArg]) -> String {
		String(format: localized(table: table, withComment: comment), locale: Locale.current, arguments: args)
	}
}

extension LocalizableKey: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.init(value)
	}
}

protocol FormattableArgument {
	var string: String { get }
	var attributes: [NSAttributedString.Key: Any] { get }
}

struct FormatArgument: FormattableArgument {
	let string: String
	let attributes: [NSAttributedString.Key: Any]

	init<StringConvertible: CustomStringConvertible>(_ stringConvertible: StringConvertible, attributes: [NSAttributedString.Key: Any] = [:]) {
		string = stringConvertible.description
		self.attributes = attributes
	}
}

struct LocalizedFormatArgument: FormattableArgument {
	let string: String
	let attributes: [NSAttributedString.Key: Any]

	init(_ localizableKey: LocalizableKey, comment: String = "", attributes: [NSAttributedString.Key: Any] = [:], shouldFormat: Bool = true, _ args: CVarArg...) {
		string = shouldFormat ? localizableKey.localizedFormat(withComment: comment, args) : localizableKey.localized()
		self.attributes = attributes
	}
}

extension FormattableArgument where Self: CustomStringConvertible {
	var string: String {
		description
	}

	var attributes: [NSAttributedString.Key: Any] {
		[:]
	}
}

extension Int: FormattableArgument {}
extension Int8: FormattableArgument {}
extension Int16: FormattableArgument {}
extension Int32: FormattableArgument {}
extension Int64: FormattableArgument {}
extension UInt: FormattableArgument {}
extension UInt8: FormattableArgument {}
extension UInt16: FormattableArgument {}
extension UInt32: FormattableArgument {}
extension UInt64: FormattableArgument {}
extension Float: FormattableArgument {}
extension Double: FormattableArgument {}

extension NSAttributedString {
	convenience init(localizableFormatKey: LocalizableKey, comment: String = "", attributes: [NSAttributedString.Key: Any] = [:], _ args: FormattableArgument...) {
		self.init(
			localizableFormatKey: localizableFormatKey,
			comment: comment,
			attributes: attributes,
			args
		)
	}

	convenience init(localizableFormatKey: LocalizableKey, comment: String = "", attributes: [NSAttributedString.Key: Any] = [:], _ args: [FormattableArgument]) {
		self.init(
			format: localizableFormatKey.localized(),
			comment: comment,
			attributes: attributes,
			args
		)
	}

	convenience init(format: String, comment: String = "", attributes: [NSAttributedString.Key: Any] = [:], _ args: FormattableArgument...) {
		self.init(
			format: format,
			comment: comment,
			attributes: attributes,
			args
		)
	}

	convenience init(format: String, comment: String = "", attributes: [NSAttributedString.Key: Any] = [:], _ args: [FormattableArgument]) {
		var formattedString = String(
			format: format,
			arguments: zip(args.indices, args).map { "_$$%\($0)-\($1.string)%$$_" }
		)
		var formattedNSString = formattedString as NSString

		var attributedString = NSMutableAttributedString(string: formattedString, attributes: attributes)
		let regex = try! NSRegularExpression(pattern: #"_\$\$%(\d+)-(.*?)%\$\$_"#, options: .dotMatchesLineSeparators)
		let results = regex.matches(in: formattedString, options: [], range: NSRange(location: 0, length: formattedNSString.length))
		var resultsInfo = results.compactMap { result in
			Int(formattedNSString.substring(with: result.range(at: 1)))
				.map { (index: $0, resultRange: result.range, stringRange: result.range(at: 2)) }
		}
		if let max = resultsInfo.map(\.index).max(), max < args.count {
			resultsInfo.sort { $0.resultRange.location < $1.resultRange.location }
			for resultInfo in resultsInfo.reversed() {
				attributedString.replaceCharacters(
					in: resultInfo.resultRange,
					with: formattedNSString.substring(with: resultInfo.stringRange)
				)
				attributedString.addAttributes(
					args[resultInfo.index].attributes,
					range: NSRange(
						location: resultInfo.resultRange.location,
						length: resultInfo.stringRange.length
					)
				)
			}
		} else {
			// Fallback to old method
			formattedString = String(format: format, arguments: args.map { $0.string })
			formattedNSString = formattedString as NSString
			attributedString = NSMutableAttributedString(string: formattedString, attributes: attributes)
			for arg in args where !arg.attributes.isEmpty {
				var range: NSRange!
				func nextRange() -> NSRange {
					range = formattedNSString.range(
						of: arg.string,
						options: [],
						range: range.map {
							NSRange(
								location: $0.location + 1,
								length: formattedNSString.length - $0.location - 1
							)
						} ?? NSRange(location: 0, length: formattedNSString.length)
					)
					return range
				}

				while nextRange().location != NSNotFound {
					attributedString.addAttributes(arg.attributes, range: range)
				}
			}
		}
		self.init(attributedString: attributedString)
	}
}
