//
//  String+PushNotificationToken.swift
//  CustomContactsHelpers
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
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
