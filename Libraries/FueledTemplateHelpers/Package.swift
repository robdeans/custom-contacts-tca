// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  FueledTemplateHelpers
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import PackageDescription

let package = Package(
	name: "FueledTemplateHelpers",
	platforms: [
		.macOS(.v11), .iOS(.v14), .tvOS(.v9), .watchOS(.v2),
	],
	products: [
		.library(
			name: "FueledTemplateHelpers",
			targets: ["FueledTemplateHelpers"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
	],
	targets: [
		.target(
			name: "FueledTemplateHelpers",
			dependencies: [
				"KeychainAccess",
			],
			path: "Sources"
		),
	]
)
