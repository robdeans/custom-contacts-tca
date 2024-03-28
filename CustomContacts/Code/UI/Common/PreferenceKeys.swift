//
//  PreferenceKeys.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/5/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
	// TODO: revert `defaultValue` to a variable when SwipeableRowView is required

	static let defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
