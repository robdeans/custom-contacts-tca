//
//  PreferenceKeys.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/5/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
	// TODO: should `defaultValue` be reverted to a variable... probably
	static let defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
