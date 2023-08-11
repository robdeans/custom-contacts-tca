//
//  String+Hash.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
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
