//
//  Constants.swift
//  CustomContactsAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

enum CurrentModule {
	static var name: String = {
		let fullName = String(reflecting: CurrentModule.self)
		if let nameRange = fullName.range(of: "CurrentModule", options: .backwards, range: nil, locale: nil) {
			return String(fullName[..<fullName.index(nameRange.lowerBound, offsetBy: -1)])
		}
		return fullName
	}()
}
