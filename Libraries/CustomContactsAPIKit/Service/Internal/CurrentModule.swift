//
//  Constants.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

enum CurrentModule {
	static let name: String = {
		let fullName = String(reflecting: CurrentModule.self)
		if let nameRange = fullName.range(of: "CurrentModule", options: .backwards, range: nil, locale: nil) {
			return String(fullName[..<fullName.index(nameRange.lowerBound, offsetBy: -1)])
		}
		return fullName
	}()
}
