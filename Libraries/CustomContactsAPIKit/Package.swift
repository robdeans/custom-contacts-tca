// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//
import PackageDescription

let package = Package(
	name: "CustomContactsAPIKit",
	platforms: [
		.macOS(.v11), .iOS(.v14), .tvOS(.v9), .watchOS(.v2),
	],
	products: [
		.library(
			name: "CustomContactsAPIKit",
			targets: ["CustomContactsAPIKit"]
		),
	],
	dependencies: [
		// global
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),

		// local
		.package(name: "ArkanaKeys", path: "../ArkanaKeys"),
		.package(name: "CustomContactsHelpers", path: "../CustomContactsHelpers"),
	],
	targets: [
		.target(
			name: "CustomContactsAPIKit",
			dependencies: [
				// global
				.product(name: "Dependencies", package: "swift-dependencies"),
				// local
				"ArkanaKeys",
				"CustomContactsHelpers",
			],
			path: "./Sources"
		),
	]
)
