//
//  String+PushNotificationToken.swift
//  CustomContactsHelpers
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

extension String {
	/// Create a string from the push notification token
	public init!(deviceToken: Data) {
		if deviceToken.count != 64 {
			return nil
		}

		var string = ""
		for byte in deviceToken {
			string.append(String(format: "%02X", byte))
		}
		self.init(string)
	}
}
