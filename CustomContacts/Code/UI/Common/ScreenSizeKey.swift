//
//  ScreenSizeKey.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
	var screenSize: CGRect {
		self[ScreenSizeKey.self]
	}
}

private struct ScreenSizeKey: EnvironmentKey {
	static var defaultValue: CGRect {
		// TODO: move away from UIScreen.main.bounds
		UIScreen.main.bounds
	}
}
