//
//  EnvironmentValues+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
	var safeAreaInsets: EdgeInsets {
		self[SafeAreaInsetsKey.self]
	}
}

private struct SafeAreaInsetsKey: EnvironmentKey {
	static var defaultValue: EdgeInsets {
		Constants.UI.SafeAreaInsets.default
	}
}
