//
//  Logging.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

// swiftlint:disable identifier_name

import OSLog

public func LogTrace(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().trace("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogDebug(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().debug("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogVerbose(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().notice("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogInfo(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().info("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogWarning(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().warning("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogError(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	#if !LOGS_DISABLED
		Logger().error("\(line):\(function):\(file) - \(message())")
	#endif
}

public func LogFatal(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) -> Never {
	#if !LOGS_DISABLED
		Logger().critical("\(line):\(function):\(file) - \(message)")
	#endif
	fatalError(message)
}
