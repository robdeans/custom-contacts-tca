//
//  PreferenceKeys.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/5/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
