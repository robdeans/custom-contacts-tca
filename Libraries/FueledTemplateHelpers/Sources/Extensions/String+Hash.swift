//
//  String+Hash.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import CryptoKit
import Foundation

extension String {
	public var md5: String {
		let data = self.data(using: .utf8)!
		return Insecure.MD5
			.hash(data: data)
			.map { String(format: "%02x", $0) }
			.joined()
	}
}
