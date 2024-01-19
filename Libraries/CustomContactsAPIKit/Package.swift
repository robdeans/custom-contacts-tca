// swift-tools-version:5.9
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
		.macOS(.v11), .iOS(.v17), .tvOS(.v12), .watchOS(.v4),
	],
	products: [
		.library(
			name: "CustomContactsAPIKit",
			targets: ["CustomContactsService", "CustomContactsModels"]
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
			name: "CustomContactsService",
			dependencies: [
				// global
				.product(name: "Dependencies", package: "swift-dependencies"),
				// local
				"ArkanaKeys",
				"CustomContactsHelpers",
				"CustomContactsModels",
			],
			path: "./Service"
		),
		.target(
			name: "CustomContactsModels",
			dependencies: [
				"CustomContactsHelpers",
			],
			path: "./Models"
		)
	]
)
