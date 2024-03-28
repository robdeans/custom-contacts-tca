//
//  UserDefaults.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import SwiftUI

@propertyWrapper
public class OptionalDefaults<Value: Codable> {
	public typealias DefaultsProjectedValue = (publisher: AnyPublisher<Value?, Never>, binding: Binding<Value?>)

	private let key: String
	private let defaultValue: Value?
	private let userDefaults: UserDefaults
	private let jsonEncoder: JSONEncoder
	private let jsonDecoder: JSONDecoder
	private let subject: CurrentValueSubject<Value?, Never>
	private var binding: Binding<Value?> {
		Binding(
			get: { self.wrappedValue },
			set: { self.wrappedValue = $0 }
		)
	}

	public var projectedValue: DefaultsProjectedValue {
		(publisher: subject.eraseToAnyPublisher(), binding: binding)
	}

	public var wrappedValue: Value? {
		get {
			storedValue ?? defaultValue
		}
		set {
			storedValue = newValue
			subject.send(newValue)
		}
	}

	public init(
		key: String,
		defaultValue: Value? = nil,
		userDefaults: UserDefaults = .standard,
		jsonEncoder: JSONEncoder = JSONEncoder(),
		jsonDecoder: JSONDecoder = JSONDecoder()
	) {
		self.key = key
		self.defaultValue = defaultValue
		self.userDefaults = userDefaults
		self.jsonEncoder = jsonEncoder
		self.jsonDecoder = jsonDecoder

		var stored: Value?
		if let data = userDefaults.data(forKey: key) {
			stored = try? jsonDecoder.decode(Value.self, from: data)
		}
		subject = CurrentValueSubject<Value?, Never>(stored ?? defaultValue)

		if storedValue == nil || data(forKey: key) == nil {
			wrappedValue = defaultValue
		}
	}
}

private extension OptionalDefaults {
	func data(forKey key: String) -> Data? {
		userDefaults.data(forKey: key)
	}

	func set(_ data: Data, forKey key: String) {
		userDefaults.set(data, forKey: key)
	}

	var storedValue: Value? {
		get {
			if let data = userDefaults.data(forKey: key) {
				return try? jsonDecoder.decode(Value.self, from: data)
			}
			return nil
		}
		set {
			if let newValue = newValue, let data = try? jsonEncoder.encode(newValue) {
				userDefaults.set(data, forKey: key)
			}
		}
	}
}

extension OptionalDefaults: Equatable where Value: Equatable {
	public static func == (lhs: OptionalDefaults<Value>, rhs: OptionalDefaults<Value>) -> Bool {
		lhs.key == rhs.key &&
		lhs.defaultValue == rhs.defaultValue &&
		lhs.wrappedValue == rhs.wrappedValue &&
		lhs.subject.value == rhs.subject.value
	}
}
