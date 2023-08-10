// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//
import PackageDescription

let package = Package(
	name: "FueledTemplateAPIKit",
	platforms: [
		.macOS(.v11), .iOS(.v14), .tvOS(.v9), .watchOS(.v2),
	],
	products: [
		.library(
			name: "FueledTemplateAPIKit",
			targets: ["FueledTemplateAPIKit"]
		),
	],
	dependencies: [
		// global
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),

		// local
		.package(name: "ArkanaKeys", path: "../ArkanaKeys"),
		.package(name: "FueledTemplateHelpers", path: "../FueledTemplateHelpers"),
	],
	targets: [
		.target(
			name: "FueledTemplateAPIKit",
			dependencies: [
				// global
				.product(name: "Dependencies", package: "swift-dependencies"),
				// local
				"ArkanaKeys",
				"FueledTemplateHelpers",
			],
			path: "./Sources"
		),
	]
)
