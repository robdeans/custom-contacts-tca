//
//  Logging.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

// swiftlint:disable identifier_name

import OSLog

public func PrintCurrentThread(_ message: @escaping @autoclosure () -> String) {
	Logger().trace("🧵 \(message()): \(String(cString: __dispatch_queue_get_label(nil)))")
}

/// This method is functionally equivilent to the debug(_:) method.
public func LogTrace(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().trace(
"""
\(line):\(function):\(file)
TRACE 🐾: \(message())
.
"""
	)
#endif
}

/// Use this method to write messages with the debug log level to the in-memory log store only.
public func LogDebug(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().debug(
"""
\(line):\(function):\(file)
DEBUG 🐛: \(message())
.
"""
	)
#endif
}

/// Use this method to write messages with the debug log level to both the in-memory and on-disk log stores.
public func LogVerbose(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().notice(
"""
\(line):\(function):\(file)
VERBOSE 📚: \(message())
.
"""
	)
#endif
}

/// Use this method to write messages with the info log level to the in-memory log store only. If you use the log command line tool to collect your logs, the method also writes messages to the on-disk log store.
public func LogInfo(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().info(
"""
\(line):\(function):\(file)
INFO 📡: \(message())
.
"""
	)
#endif
}

/// This method is functionally equivalent to the error(_:) method.
public func LogWarning(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().warning(
"""
\(line):\(function):\(file)
WARNING ⚠️: \(message())
.
"""
	)
#endif
}

/// Use this method to write messages with the error log level to both the in-memory and on-disk log stores.
public func LogError(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
#if !LOGS_DISABLED
	Logger().error(
"""
\(line):\(function):\(file)
ERROR ❌: \(message())
.
"""
	)
#endif
}

/// Use this method to write messages with the fault log level to both the in-memory and on-disk log stores.
public func LogFatal(_ message: String, file: String = #file, function: String = #function, line: UInt = #line) -> Never {
#if !LOGS_DISABLED
	Logger().critical(
"""
\(line):\(function):\(file)
FATAL ☢️: \(message)
.
"""
	)
#endif
	fatalError(message)
}
