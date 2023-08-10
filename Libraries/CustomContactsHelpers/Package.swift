// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import PackageDescription

let package = Package(
	name: "CustomContactsHelpers",
	platforms: [
		.macOS(.v11), .iOS(.v14), .tvOS(.v9), .watchOS(.v2),
	],
	products: [
		.library(
			name: "CustomContactsHelpers",
			targets: ["CustomContactsHelpers"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
	],
	targets: [
		.target(
			name: "CustomContactsHelpers",
			dependencies: [
				"KeychainAccess",
			],
			path: "Sources"
		),
	]
)
